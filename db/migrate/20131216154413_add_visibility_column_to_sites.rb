class AddVisibilityColumnToSites < ActiveRecord::Migration
  def change
    add_column :sites, :visible, :boolean, null: false, default: true
    add_index :sites, :visible
  end
end
