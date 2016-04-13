class AddNumberOfDevicesToBillingDetails < ActiveRecord::Migration
  def change
    add_column :billing_details, :number_of_devices, :integer, default: 0
  end
end
