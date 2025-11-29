require "googleauth"
require "net/http"
require "uri"
require "json"

class PushNotificationSender
  FCM_URL = "https://fcm.googleapis.com/v1/projects/#{Rails.application.credentials.fcm[:project_id]}/messages:send"

  def self.send_notification(tokens, payload = {})
    return if tokens.blank?

    tokens.each do |token|
      send_to_single_device(token, payload)
    end
  end

  def self.send_to_single_device(token, payload)
    access_token = get_access_token

    body = {
      message: {
        token: token,
        notification: {
          title: payload[:title],
          body: payload[:body]
        }
      }
    }

    uri = URI.parse(FCM_URL)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{access_token}"
    })

    request.body = body.to_json
    response = https.request(request)

    Rails.logger.info "FCM response for token #{token}: #{response.body}"
    response
  end

  def self.get_access_token
    scope = "https://www.googleapis.com/auth/firebase.messaging"

    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(service_account_json),
      scope: scope
    )

    authorizer.fetch_access_token!
    authorizer.access_token
  end

  def self.service_account_json
    {
      type: "service_account",
      project_id: Rails.application.credentials.fcm[:project_id],
      private_key_id: "dummy", # not used
      private_key: Rails.application.credentials.fcm[:private_key],
      client_email: Rails.application.credentials.fcm[:client_email],
      client_id: "dummy",
      token_uri: Rails.application.credentials.fcm[:token_uri]
    }.to_json
  end
end
