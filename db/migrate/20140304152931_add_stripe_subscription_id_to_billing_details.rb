class AddStripeSubscriptionIdToBillingDetails < ActiveRecord::Migration
  def change
    add_column :billing_details, :stripe_subscription_id, :string
  end
end
