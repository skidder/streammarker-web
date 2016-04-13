# Add last-checkin field to devices
class AddLastCheckinToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :last_checkin, :datetime
  end
end
