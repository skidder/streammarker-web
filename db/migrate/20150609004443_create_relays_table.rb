class CreateRelaysTable < ActiveRecord::Migration
  def change
    create_table :relays do |t|
      t.integer :user_id, null: false
      t.string :name
      t.string :uuid

      t.timestamps
    end
  end
end
