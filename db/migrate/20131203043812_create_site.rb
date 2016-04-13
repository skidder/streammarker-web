class CreateSite < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :description
      t.float :latitude
      t.float :longitude
      t.string :network_name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
