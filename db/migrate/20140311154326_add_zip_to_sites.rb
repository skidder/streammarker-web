class AddZipToSites < ActiveRecord::Migration
  def change
    add_column :sites, :zip, :string
  end
end
