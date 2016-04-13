class AddShippingAddressToDeviceOrder < ActiveRecord::Migration
  def change
    add_column :device_orders, :address1, :string
    add_column :device_orders, :address2, :string
    add_column :device_orders, :city,     :string
    add_column :device_orders, :state,    :string
    add_column :device_orders, :zip,      :string
    add_column :device_orders, :country,  :string
  end
end
