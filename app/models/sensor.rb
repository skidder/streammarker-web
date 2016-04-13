class Sensor < ActiveRecord::Base
  validates :name, length: { maximum: 200 }
  validates_inclusion_of :state, in: %w( Active Inactive ), message: 'state %{value} is not included in the list'
  validates :latitude, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :sample_frequency, numericality: { only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 1440 }
end
