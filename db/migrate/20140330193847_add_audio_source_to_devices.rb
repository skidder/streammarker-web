class AddAudioSourceToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :audio_source, :string, null: false, default: 'line-in'
  end
end
