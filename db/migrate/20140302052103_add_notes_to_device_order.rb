class AddNotesToDeviceOrder < ActiveRecord::Migration
  def change
    add_column :device_orders, :notes, :text
  end
end
