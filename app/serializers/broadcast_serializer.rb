# app/serializers/broadcast_serializer.rb
class BroadcastSerializer < ActiveModel::Serializer
  attributes :id, :title, :message, :status, :sent_at, :user_id, :created_at, :updated_at
end
