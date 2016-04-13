class AddLatLongToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :latitude, :float
    add_column :sensors, :longitude, :float
  end
end
