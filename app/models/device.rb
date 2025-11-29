# app/models/device.rb
class Device < ApplicationRecord
  belongs_to :user

  # we use `token` column for the push token (FCM/APNs token)
  validates :token, presence: true, uniqueness: { scope: :user_id, allow_nil: false }
  validates :platform, allow_nil: true, length: { maximum: 50 }
end
