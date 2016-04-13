class AddTimezoneToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :timezone_id, :string
    add_column :sensors, :timezone_name, :string
  end
end
