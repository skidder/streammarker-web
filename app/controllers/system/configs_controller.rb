# System Config controller
class System::ConfigsController < ApplicationController
  before_action :signed_in_admin
  before_action :set_configs, only: [:index]
  before_action :set_config, only: [:destroy, :edit, :update]

  def new
    @config = SystemConfig.new
  end

  def create
    @config = SystemConfig.new(config_params)

    respond_to do |format|
      if @config.save
        format.html do
          redirect_to system_configs_path, notice: 'Config item was successfully created.'
        end
      else
        format.html do
          render action: 'new'
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @config.update(config_params)
        format.html do
          redirect_to system_configs_path, notice: 'Config item was successfully updated.'
        end
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @config.destroy
    respond_to do |format|
      format.html { redirect_to system_configs_path }
    end
  end

  private

  def set_configs
    @configs = SystemConfig.all
  end

  def set_config
    @config = SystemConfig.find(params[:id])
  end

  def config_params
    params.require(:system_config).permit(:key, :value)
  end
end
