class AddAPIKeyToRoutingRules < ActiveRecord::Migration
  def change
    add_column :routing_rules, :api_key, :string
  end
end
