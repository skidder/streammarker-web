class AddAddress2ToSite < ActiveRecord::Migration
  def change
    rename_column :sites, :street_address, :address1

    add_column :sites, :address2, :string
  end
end
