class AddCreditCardTypeAndExpirationDateToBillingDetails < ActiveRecord::Migration
  def change
    rename_column :billing_details, :last_4_digits, :card_last_4_digits

    add_column :billing_details, :card_exp_month, :integer
    add_column :billing_details, :card_exp_year,  :integer
    add_column :billing_details, :card_type,      :string
  end
end
