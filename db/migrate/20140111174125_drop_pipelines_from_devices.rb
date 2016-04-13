class DropPipelinesFromDevices < ActiveRecord::Migration
  def change
    remove_column :devices, :playback_pipeline
    remove_column :devices, :encode_pipeline
  end
end
