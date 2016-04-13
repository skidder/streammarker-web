class DropSubscriptions < ActiveRecord::Migration
  def change
    drop_table :routing_rules
    drop_table :subscriptions
  end
end
