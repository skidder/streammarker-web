class ChangeCableTypeDefaultOnDeviceOrders < ActiveRecord::Migration
  def change
    change_column_default :device_orders, :cable_type, '3.5 mm Stereo Connector Cable'
  end
end
