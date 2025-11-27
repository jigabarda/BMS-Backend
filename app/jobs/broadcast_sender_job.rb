class BroadcastSenderJob < ApplicationJob
  queue_as :default

  def perform(broadcast_id, user_id)
    broadcast = Broadcast.find(broadcast_id)
    user = User.find(user_id)

    # Get all device tokens (for simplicity, send to all devices)
    tokens = Device.pluck(:push_token)
    return if tokens.empty?

    options = {
      priority: "high",
      notification: {
        title: broadcast.title,
        body: broadcast.message,
        sound: "default"
      },
      data: {
        broadcast_id: broadcast.id,
        sent_at: Time.current.iso8601
      }
    }

    response = FCM_CLIENT.send(tokens, options)
    # Response parsing: record status
    broadcast.update(status: 'sent', sent_at: Time.current)

    # broadcast via ActionCable so web dashboards can update status
    ActionCable.server.broadcast("broadcasts_channel", { action: 'sent', broadcast: broadcast.as_json })
  rescue => e
    Rails.logger.error("Failed to send broadcast: #{e.message}")
    # Optional: mark failed status
    broadcast.update(status: 'failed') if broadcast
  end
end
