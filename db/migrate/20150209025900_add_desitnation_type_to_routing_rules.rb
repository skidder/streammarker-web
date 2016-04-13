class AddDesitnationTypeToRoutingRules < ActiveRecord::Migration
  def change
    add_column :routing_rules, :destination_type, :string
  end
end
