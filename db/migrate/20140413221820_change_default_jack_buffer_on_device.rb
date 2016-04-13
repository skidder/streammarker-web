class ChangeDefaultJackBufferOnDevice < ActiveRecord::Migration
  def change
    change_column_default :devices, :encoding_jack_buffer, 30_000
  end
end
