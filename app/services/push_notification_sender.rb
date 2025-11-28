# app/services/push_notification_sender.rb
# Minimal adapter — replace with FCM/APNs integration (fcm gem or http calls).
class PushNotificationSender
  # tokens: array of push tokens (strings)
  # payload: hash with title/body/other
  def self.send_notification(tokens, payload = {})
    return if tokens.blank?

    # For now, just log. Replace this block with real FCM call.
    Rails.logger.info "PushNotificationSender: would send to #{tokens.size} tokens"
    Rails.logger.info "Payload: #{payload.inspect}"
    # Example FCM pseudo:
    # fcm = FCM.new(ENV['FCM_SERVER_KEY'])
    # response = fcm.send(tokens, { notification: payload })
    # Rails.logger.info "FCM response: #{response.inspect}"
    true
  end
end
