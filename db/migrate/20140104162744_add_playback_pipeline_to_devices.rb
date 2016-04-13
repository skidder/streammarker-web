class AddPlaybackPipelineToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :playback_pipeline, :text
  end
end
