class AddEmailVerificationToUsers < ActiveRecord::Migration
  def change
    create_table :email_verifications do |t|
      t.integer :user_id, null: false

      t.string :code
      t.boolean :verified, default: false
      t.string :last_verified_at
    end
  end
end
