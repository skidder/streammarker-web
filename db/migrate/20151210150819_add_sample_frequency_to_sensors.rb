class AddSampleFrequencyToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :sample_frequency, :int
  end
end
