class AddStreamingParametersToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :playback_rtp_jitter_buffer, :integer, default: 60, null: false
    add_column :devices, :encoding_frame_size, :integer, default: 20, null: false
    add_column :devices, :encoding_bitrate, :integer, default: 18_000, null: false
    add_column :devices, :encoding_complexity, :integer, default: 5, null: false
    add_column :devices, :encoding_jack_buffer, :integer, default: 30_000, null: false
    add_column :devices, :encoding_bandwidth, :string, default: 'wideband', null: false
  end
end
