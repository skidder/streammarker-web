class AddRegionToRoutingRules < ActiveRecord::Migration
  def change
    add_column :routing_rules, :region, :string
  end
end
