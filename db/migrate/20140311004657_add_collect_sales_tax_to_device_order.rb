class AddCollectSalesTaxToDeviceOrder < ActiveRecord::Migration
  def change
    add_column :device_orders, :collect_sales_tax, :boolean, default: false
  end
end
