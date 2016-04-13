class AddDeviceOrderIdToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :device_order_id, :integer
  end
end
