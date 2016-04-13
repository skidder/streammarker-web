# Create Billing Details table
class CreateBillingDetails < ActiveRecord::Migration
  def change
    create_table :billing_details do |t|
      t.integer :user_id, null: false
      t.integer :plan_id, null: false
      t.string :last_4_digits
      t.string :stripe_id
      t.boolean :subscribed, default: false
      t.timestamps
    end
  end
end
