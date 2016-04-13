class AddNumberOfDevicesToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :number_of_devices, :integer
  end
end
