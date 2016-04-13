class AddCollectSalesTaxToBillingDetails < ActiveRecord::Migration
  def change
    add_column :billing_details, :collect_sales_tax, :boolean, default: false
  end
end
