class RenameDeviceUuidToAPIKey < ActiveRecord::Migration
  def change
    rename_column :readers, :uuid, :api_key
  end
end
