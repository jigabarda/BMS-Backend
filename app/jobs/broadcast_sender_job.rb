# app/jobs/broadcast_sender_job.rb
class BroadcastSenderJob < ApplicationJob
  queue_as :default

  def perform(broadcast_id)
    broadcast = Broadcast.find_by(id: broadcast_id)
    return unless broadcast

    begin
      # Fetch user's devices
      tokens = broadcast.user.devices.pluck(:token).compact.uniq
      # Use a service class to actually send push notifications (FCM / APNs).
      # Here we call PushNotificationSender (provided below); adapt to your provider.
      PushNotificationSender.send_notification(tokens, title: broadcast.title, body: broadcast.message)

      broadcast.update!(status: 'sent', sent_at: Time.current)
    rescue => e
      Rails.logger.error "BroadcastSenderJob failed: #{e.class} #{e.message}\n#{e.backtrace.join("\n")}"
      broadcast.update!(status: 'failed') if broadcast
    end
  end
end
