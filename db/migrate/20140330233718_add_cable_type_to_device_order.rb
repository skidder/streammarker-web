class AddCableTypeToDeviceOrder < ActiveRecord::Migration
  def change
    add_column :device_orders, :cable_type, :string, null: false, default: 'line-in'
  end
end
