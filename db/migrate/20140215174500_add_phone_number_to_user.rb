# Add phone-number field to users
class AddPhoneNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
  end
end
