class AddMulticastPortToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :multicast_port, :integer, null: false, default: 0
  end
end
