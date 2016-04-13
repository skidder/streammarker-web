class RemoveNotNullConstraintForSiteOnDevices < ActiveRecord::Migration
  def change
    change_column_null(:devices, :site_id, true)
  end
end
