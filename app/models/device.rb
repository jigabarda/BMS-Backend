# app/models/device.rb
class Device < ApplicationRecord
  belongs_to :user

  validates :token, presence: true
  validates :platform, allow_nil: true, length: { maximum: 50 }
end
