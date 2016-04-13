class AddAddressToBillingDetails < ActiveRecord::Migration
  def change
    add_column :billing_details, :address1, :string
    add_column :billing_details, :address2, :string
    add_column :billing_details, :city,     :string
    add_column :billing_details, :state,    :string
    add_column :billing_details, :country,  :string
  end
end
