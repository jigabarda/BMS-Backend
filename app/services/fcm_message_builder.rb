# app/services/fcm_message_builder.rb

class FcmMessageBuilder
  def initialize(token:, title:, body:)
    @token = token
    @title = title
    @body = body
  end

  def build
    {
      message: {
        token: @token,
        notification: {
          title: @title,
          body: @body
        },
        android: {
          priority: "high"
        },
        apns: {
          headers: { "apns-priority": "10" }
        }
      }
    }
  end
end
