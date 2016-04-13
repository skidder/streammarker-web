require 'date'
require 'json'

class DashboardController < ApplicationController
  before_action :signed_in_user
  before_action :set_user
  before_action :authorize_user
  before_action :set_sensors
  before_action :set_last_sensor_readings
  before_action :set_relays

  def index
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:first_name,
              :last_name,
              :company,
              :phone_number,
              :email,
              :password,
              :password_confirmation)
  end

  def set_relays
    @relays = @user.relays
  end

  def set_user
    @user = User.find(current_user.id)
  end

  def set_sensors
    response = HTTParty.get("#{STREAMMARKER_DATA_ACCESS_URL}/data-access/v1/sensors/account/#{@user.account_id}?state=active",
                            headers: { 'Accept' => 'application/json',
                                       'Accept-Encoding' => 'gzip',
                                       'X-API-KEY' => Rails.configuration.x.data_access.token })
    @sensors = JSON.parse(response.body)['sensors'] if response.code.to_i == 200
  end

  def set_last_sensor_readings
    response = HTTParty.get("#{STREAMMARKER_DATA_ACCESS_URL}/data-access/v1/last_sensor_readings/account/#{@user.account_id}?state=active",
                            headers: { 'Accept' => 'application/json',
                                       'Accept-Encoding' => 'gzip',
                                       'X-API-KEY' => Rails.configuration.x.data_access.token })
    if response.code.to_i == 200
      @last_sensor_readings = JSON.parse(response.body)['sensors']
      if cookies[:temperature_scale] == 'fahrenheit'
        @last_sensor_readings.each do |_sensor_id, sensor_data|
          sensor_data['measurements'].each do |m|
            if m['unit'] == 'Celsius'
              m['value'] = ((m['value'].to_f * 1.8) + 32)
              m['unit'] = 'Fahrenheit'
            end
          end
        end
      end
    end
  end

  def authorize_user
    unless @user == current_user
      flash[:error] = 'You must be logged in to access this section'
      redirect_to root_url # halts request cycle
    end
  end
end
