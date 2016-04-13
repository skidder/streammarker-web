class CreateSensorsTable < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :name
      t.string :account_id
      t.string :uuid
    end
  end
end
