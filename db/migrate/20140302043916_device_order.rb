class DeviceOrder < ActiveRecord::Migration
  def change
    create_table :device_orders do |t|
      t.integer :user_id, null: false
      t.integer :quantity, null: false
      t.boolean :completed, default: false, null: false
      t.timestamps
    end
  end
end
