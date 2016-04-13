class RemoveNotNullConstraintOnBillingDetailsPlanId < ActiveRecord::Migration
  def change
    change_column_null(:billing_details, :plan_id, true)
  end
end
