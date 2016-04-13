class AddEncodePipelineToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :encode_pipeline, :text
  end
end
