class AddForcePasswordChangeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :force_password_change, :boolean, null: false, default: false
  end
end
