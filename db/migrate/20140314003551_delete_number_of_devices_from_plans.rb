class DeleteNumberOfDevicesFromPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :number_of_devices
  end
end
