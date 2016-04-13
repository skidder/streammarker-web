class AddNameToRoutingRules < ActiveRecord::Migration
  def change
    add_column :routing_rules, :name, :string
    rename_column :routing_rules, :aws_queue_name, :aws_destination_name
  end
end
