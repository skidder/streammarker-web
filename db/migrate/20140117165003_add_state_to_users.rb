# Add state to users
class AddStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :state, :string
    change_column_default :users, :state, 'active'
  end
end
