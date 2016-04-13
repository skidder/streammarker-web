class RenameRoutingRulesFields < ActiveRecord::Migration
  def change
    rename_column :routing_rules, :aws_destination_name, :destination
    remove_column :routing_rules, :aws_account_id
    remove_column :routing_rules, :region
  end
end
