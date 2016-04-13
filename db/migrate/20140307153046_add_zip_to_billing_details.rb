class AddZipToBillingDetails < ActiveRecord::Migration
  def change
    add_column :billing_details, :zip, :string
  end
end
