require 'date'
require 'redis'
require 'json'
require 'solareventcalculator'
require 'tzinfo'

class SensorReadingsController < ApplicationController
  before_action :signed_in_user, only: [:query, :graph]
  before_action :set_user, only: [:query, :graph]
  before_action :set_sensor, only: [:query, :graph]
  before_action :authorize_user, only: [:query, :graph]

  def graph
    @sensor_id = params[:sensor_id]
    @measurement = params[:measurement]
    @start_time = params[:start_time] || 86_400
    @temperature_scale = params[:temperature_scale].nil? ? cookies[:temperature_scale] : params[:temperature_scale]
    @temperature_scale = 'celsius' if @temperature_scale.nil?

    # update browser cookie if scale was given in params
    if params[:temperature_scale]
      cookies.permanent[:temperature_scale] = @temperature_scale
    end

    if @measurement.starts_with?('soil_moisture')
      @reading_name = 'Soil Moisture'
      @reading_unit = 'VWC'
    elsif @measurement.starts_with?('soil_temperature')
      @reading_name = 'Soil Temperature'
      @reading_unit = "Degrees #{@temperature_scale == '' ? 'Celsius' : @temperature_scale.capitalize}"
    elsif @measurement.starts_with?('enclosure_temperature')
      @reading_name = 'Enclosure Temperature'
      @reading_unit = "Degrees #{@temperature_scale == '' ? 'Celsius' : @temperature_scale.capitalize}"
    elsif @measurement.starts_with?('external_temperature')
      @reading_name = 'External Temperature'
      @reading_unit = "Degrees #{@temperature_scale == '' ? 'Celsius' : @temperature_scale.capitalize}"
    elsif @measurement.starts_with?('external_humidity')
      @reading_name = 'External Humidity'
      @reading_unit = 'RH'
    else
      @reading_name = 'Unknown'
      @reading_unit = 'Unknown'
    end

    @solar_events = []
    if @sensor['latitude'] && @sensor['longitude']
      (-2..[((@start_time.to_i) / 86_400), 1].max).to_a.each do |i|
        calc = SolarEventCalculator.new(Time.now.to_date.prev_day(i), BigDecimal.new(@sensor['latitude'].to_s), BigDecimal.new(@sensor['longitude'].to_s))
        sunrise = calc.compute_utc_official_sunrise.strftime('%Q')
        sunset = calc.compute_utc_official_sunset.strftime('%Q')
        @solar_events << { sunrise: sunrise, sunset: sunset } if sunrise && sunset
      end
    end

    if @sensor['timezone_id']
      # http://stackoverflow.com/a/9962118
      tz = TZInfo::Timezone.get(@sensor['timezone_id'])
      current = tz.current_period
      if current.dst?
        @tz_offset_minutes = (-1 * (current.utc_total_offset / 60))
      else
        @tz_offset_minutes = (-1 * (current.utc_offset / 60))
      end
    else
      @tz_offset_minutes = 0
    end
  end

  # GET /sensor_readings/query
  def query
    # query in 24-hour increments
    sensor_id = params[:sensor_id]
    overall_query_start_time = params[:start_time].to_i.seconds.ago
    overall_query_end_time = DateTime.now

    grouped_readings = []
    last_segment_query_executed = false
    segment_query_start_time = nil
    segment_query_end_time = nil
    until last_segment_query_executed
      cache_results = false
      if segment_query_start_time.nil? && segment_query_end_time.nil?
        segment_query_start_time = overall_query_end_time.at_beginning_of_hour
        segment_query_end_time = overall_query_end_time
      else
        cache_results = true
        segment_query_end_time = segment_query_start_time
        segment_query_start_time -= 1.hour
      end

      # trim the end-time and exit the loop if we're on the last segment
      if segment_query_start_time.to_i < overall_query_start_time.to_i
        segment_query_start_time = overall_query_start_time
        last_segment_query_executed = true
        cache_results = false
      end

      # check Redis cache for result
      segment_cache_key = "#{sensor_id}_#{segment_query_start_time.strftime('%s')}_#{segment_query_end_time.strftime('%s')}"
      segment_results = redis_client.get segment_cache_key

      # if we didn't find results in the cache then query data-access-service
      unless segment_results
        segment_query_url = "#{STREAMMARKER_DATA_ACCESS_URL}/data-access/v1/sensor_readings?account_id=#{current_user.account_id}&sensor_id=#{params[:sensor_id]}&start_time=#{segment_query_start_time.to_i}&end_time=#{segment_query_end_time.to_i}"
        puts "Hitting query URL: #{segment_query_url}"
        @response = HTTParty.get(segment_query_url,
                                 headers: { 'Accept' => 'application/json',
                                            'Accept-Encoding' => 'gzip',
                                            'X-API-KEY' => Rails.configuration.x.data_access.token })
        if @response.code.to_i == 200
          segment_results = @response.body
          redis_client.setex segment_cache_key, 7.days.to_i, segment_results if cache_results
        end
      end

      next unless segment_results
      JSON.parse(segment_results)['readings'].each do |e|
        e['measurements'].each do |measurement|
          next unless measurement['name'] == params[:measurement]
          if params[:measurement].include?('temperature')
            if cookies['temperature_scale'] == 'fahrenheit'
              grouped_readings << [e['timestamp'] * 1000, ((measurement['value'].to_f * (1.8)) + 32).round(2)]
            else
              grouped_readings << [e['timestamp'] * 1000, measurement['value']]
            end
          else
            grouped_readings << [e['timestamp'] * 1000, measurement['value']]
          end
        end
      end
    end
    render json: grouped_readings.reverse
  end

  private

  def dynamo_client
    Aws::DynamoDB::Client.new
  end

  def redis_client
    @redis_client ||= Redis.new
  end

  def set_sensor
    @response = HTTParty.get("#{STREAMMARKER_DATA_ACCESS_URL}/data-access/v1/sensor/#{params[:sensor_id]}",
                             headers: { 'Accept' => 'application/json',
                                        'Accept-Encoding' => 'gzip',
                                        'X-API-KEY' => Rails.configuration.x.data_access.token })
    @sensor = JSON.parse(@response.body) if @response.code.to_i == 200
  end

  def set_user
    @user = current_user
  end

  def authorize_user
    if @user.nil? || @sensor.nil? || @user.account_id != @sensor['account_id']
      flash[:error] = 'You must be logged in to access this section'
      redirect_to root_url # halts request cycle
    end
  end
end
