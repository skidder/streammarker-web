class AddGStreamerCapsToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :streaming_ssrc,             :integer
    add_column :devices, :streaming_timestamp_offset, :integer
    add_column :devices, :streaming_seqnum_offset,    :integer
  end
end
