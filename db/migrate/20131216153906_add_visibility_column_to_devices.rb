class AddVisibilityColumnToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :visible, :boolean, null: false, default: true
    add_index :devices, :visible
  end
end
