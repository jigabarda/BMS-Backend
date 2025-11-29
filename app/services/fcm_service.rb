# app/services/fcm_client.rb
require "googleauth"
require "net/http"
require "uri"
require "json"

class FcmClient
  FCM_SCOPE = "https://www.googleapis.com/auth/firebase.messaging".freeze

  def initialize
    creds = Rails.application.credentials.fcm

    @project_id = creds[:project_id]
    @client_email = creds[:client_email]
    @private_key = creds[:private_key]
    @token_uri = creds[:token_uri]

    @authorizer = Google::Auth::ServiceAccountCredentials.new(
      token_credential_uri: @token_uri,
      audience: @token_uri,
      scope: FCM_SCOPE,
      issuer: @client_email,
      signing_key: OpenSSL::PKey::RSA.new(@private_key)
    )
  end

  # Sends a message to FCM HTTP v1
  def send_message(message_payload)
    uri = URI("https://fcm.googleapis.com/v1/projects/#{@project_id}/messages:send")

    # Auto refresh OAuth token
    @authorizer.fetch_access_token!
    access_token = @authorizer.access_token

    headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{access_token}"
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri.request_uri, headers)
    req.body = JSON.dump(message_payload)

    response = http.request(req)
    parse_response(response)
  end

  private

  def parse_response(response)
    body = JSON.parse(response.body) rescue {}

    if response.code.to_i >= 400
      Rails.logger.error("FCM ERROR #{response.code}: #{body}")
      return { success: false, error: body }
    end

    { success: true, response: body }
  end
end
