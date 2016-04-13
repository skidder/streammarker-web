class AddDemoToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :demo, :boolean, null: false, default: false
  end
end
