class AddLastCommitToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :last_commit, :string
  end
end
