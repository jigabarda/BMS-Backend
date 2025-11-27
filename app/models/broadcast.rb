class Broadcast < ApplicationRecord
  belongs_to :user
  validates :title, :message, presence: true

  enum status: { pending: "pending", sent: "sent" }
end
