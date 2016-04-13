class ChangeCapsFieldTypesOnDevice < ActiveRecord::Migration
  def change
    remove_column :devices, :streaming_ssrc
    remove_column :devices, :streaming_timestamp_offset
    remove_column :devices, :streaming_seqnum_offset

    add_column :devices, :streaming_ssrc,             :string
    add_column :devices, :streaming_timestamp_offset, :string
    add_column :devices, :streaming_seqnum_offset,    :string
  end
end
