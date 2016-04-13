class ChangeDeviceEncodingDefaultsOnDevice < ActiveRecord::Migration
  def change
    change_column_default :devices, :encoding_frame_size, 10
    change_column_default :devices, :encoding_jack_buffer, 20_000
  end
end
