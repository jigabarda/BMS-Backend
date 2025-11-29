# app/jobs/broadcast_sender_job.rb

class BroadcastSenderJob < ApplicationJob
  queue_as :default

  def perform(broadcast_id)
    broadcast = Broadcast.find(broadcast_id)
    user = broadcast.user

    fcm = FcmClient.new

    user.devices.find_each do |device|
      msg = FcmMessageBuilder.new(
        token: device.token,
        title: broadcast.title,
        body: broadcast.message
      ).build

      result = fcm.send_message(msg)
      Rails.logger.info("FCM RESULT for device #{device.id}: #{result}")
    end

    broadcast.update!(status: "sent")
  end
end
