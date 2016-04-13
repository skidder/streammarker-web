class CreateDevice < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :user_id, null: false
      t.integer :site_id, null: false
      t.string :name, null: false
      t.string :factory_id, null: false

      t.timestamps
    end
  end
end
