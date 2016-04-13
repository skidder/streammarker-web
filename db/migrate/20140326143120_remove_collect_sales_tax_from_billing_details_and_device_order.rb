class RemoveCollectSalesTaxFromBillingDetailsAndDeviceOrder < ActiveRecord::Migration
  def change
    remove_column :billing_details, :collect_sales_tax
    remove_column :device_orders, :collect_sales_tax
  end
end
