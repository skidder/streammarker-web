class AddLocationEnabledToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :location_enabled, :boolean, null: false, default: true
  end
end
