class DropEasyListenrTables < ActiveRecord::Migration
  def change
    drop_table :device_orders
    drop_table :devices
    drop_table :sites
  end
end
