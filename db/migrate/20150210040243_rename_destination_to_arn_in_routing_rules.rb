class RenameDestinationToArnInRoutingRules < ActiveRecord::Migration
  def change
    rename_column :routing_rules, :destination, :arn
  end
end
