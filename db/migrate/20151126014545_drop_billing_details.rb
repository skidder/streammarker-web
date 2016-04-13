class DropBillingDetails < ActiveRecord::Migration
  def change
    drop_table :billing_details
  end
end
