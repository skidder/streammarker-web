class AddStateToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :state, :string
  end
end
