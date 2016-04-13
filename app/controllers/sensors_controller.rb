class SensorsController < ApplicationController
  before_action :signed_in_user
  before_action :set_sensors, only: [:index]
  before_action :set_sensor, only: [:show, :edit, :update]
  before_action :authorize_user, only: [:show, :edit, :update]

  # PATCH/PUT /relays/1
  # PATCH/PUT /relays/1.json
  def update
    if @sensor.valid?
      put_sensor_dynamodb_record(@sensor)
      redirect_to sensors_path, notice: 'Sensor was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private

  def put_sensor_dynamodb_record(sensor)
    @request = {
      name: sensor.name,
      location_enabled: sensor.location_enabled,
      latitude: sensor.latitude,
      longitude: sensor.longitude,
      sample_frequency: sensor.sample_frequency,
      state: sensor.state.downcase
    }.to_json
    @response = HTTParty.put("#{STREAMMARKER_DATA_ACCESS_URL}/data-access/v1/sensor/#{sensor.uuid}",
                             body: @request,
                             headers: { 'Content-Type' => 'application/json',
                                        'X-API-KEY' => Rails.configuration.x.data_access.token })
  end

  def set_sensor
    if params[:sensor]
      @sensor = get_sensor(params[:sensor][:id])
      @sensor.name = params[:sensor][:name]
      @sensor.location_enabled = params[:sensor][:location_enabled]
      @sensor.latitude = params[:sensor][:latitude]
      @sensor.longitude = params[:sensor][:longitude]
      @sensor.state = params[:sensor][:state]
      @sensor.sample_frequency = params[:sensor][:sample_frequency]
    elsif params[:id]
      @sensor = get_sensor(params[:id])
    end
  end

  def get_sensor(uuid)
    @response = HTTParty.get("#{STREAMMARKER_DATA_ACCESS_URL}/data-access/v1/sensor/#{uuid}",
                             headers: { 'Accept' => 'application/json',
                                        'Accept-Encoding' => 'gzip',
                                        'X-API-KEY' => Rails.configuration.x.data_access.token })
    if @response.code.to_i == 200
      @sensor = Sensor.new(JSON.parse(@response.body))
      @sensor.uuid = uuid
      return @sensor
    end
  end

  def set_sensors
    response = HTTParty.get("#{STREAMMARKER_DATA_ACCESS_URL}/data-access/v1/sensors/account/#{current_user.account_id}",
                            headers: { 'Accept' => 'application/json',
                                       'Accept-Encoding' => 'gzip',
                                       'X-API-KEY' => Rails.configuration.x.data_access.token })
    @sensors = JSON.parse(response.body)['sensors'] if response.code.to_i == 200
  end

  def authorize_user
    if current_user.nil? || @sensor.nil? || @sensor.account_id != current_user.account_id
      flash[:error] = 'You must be logged in to access this section'
      redirect_to root_url # halts request cycle
    end
  end

  def sensor_params
    params.require(:sensor).permit(:name, :location_enabled, :longitude, :latitude, :sample_frequency, :state, :id)
  end
end
