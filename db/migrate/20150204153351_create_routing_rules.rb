class CreateRoutingRules < ActiveRecord::Migration
  def change
    create_table :routing_rules do |t|
      t.integer :user_id, null: false
      t.string :aws_account_id
      t.string :aws_queue_name

      t.timestamps
    end
  end
end
