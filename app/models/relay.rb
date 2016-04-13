# Relay model
class Relay < ActiveRecord::Base
  validates :name, presence: true
  validates :uuid, format: { with: /[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/, message: 'only allows UUID values' }

  belongs_to :user
end
