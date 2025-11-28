# app/models/broadcast.rb
class Broadcast < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :message, presence: true
  validates :status, inclusion: { in: %w[pending queued sent failed], allow_nil: true }

  scope :recent, -> { order(created_at: :desc) }
end
