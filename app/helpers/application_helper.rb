# Global helper methods
module ApplicationHelper
  def full_title(page_title)
    base_title = 'StreamMarker'
    if base_title.present?
      "#{base_title} | #{page_title}"
    else
      base_title
    end
  end

  def bootstrap_class_for(flash_type)
    case flash_type
    when :success
      'alert-success'
    when :error
      'alert-danger'
    when :alert
      'alert-warning'
    when :notice
      'alert-info'
    else
      'alert-warning'
    end
  end

  def measurement_unit(unit_name)
    case unit_name
    when 'Fahrenheit'
      '°F'
    when 'Celsius'
      '°C'
    else
      unit_name
    end
  end

  def currency(value)
    number_to_currency(value / 100.0)
  end

  def show_epoch_ts(ts)
    DateTime.strptime("#{ts}", '%s').strftime('%A, %d %B %Y')
  end

  def time_ago(time, append = ' ago')
    time_ago_in_words(time)
      .gsub(/about|less than|almost|over/, '')
      .strip << append
  end

  def dynamo_client
    @ddb ||= AWS::DynamoDB::Client.new
  end

  def sensor_location(sensor)
    if sensor['location_enabled'] && sensor['latitude'] && sensor['longitude']
      "#{sensor['latitude']}/#{sensor['longitude']}"
    else
      ''
    end
  end

  def sensor_name(name)
    if name.blank?
      'Unnamed Sensor'
    else
      name
    end
  end

  def get_reading(sensor, reading_name)
    if !sensor.nil? && !sensor['measurements'].nil?
      sensor['measurements'].each do |m|
        if m['name'] == reading_name
          return "#{m['value'].to_f.round(2)} #{measurement_unit(m['unit'])}"
        end
      end
    end
    ''
  end
end
