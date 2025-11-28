require 'net/http'
require 'uri'
require 'json'

class FcmService
  FCM_ENDPOINT = URI.parse('https://fcm.googleapis.com/fcm/send').freeze

  # tokens: array of strings
  # payload: hash (will be merged into request)
  # returns { success: true/false, http_code: ..., body: parsed_json_or_text }
  def self.send_to_tokens(tokens, payload)
    server_key = ENV['FCM_SERVER_KEY']
    unless server_key.present?
      return { success: false, error: 'FCM_SERVER_KEY not configured' }
    end

    body = payload.merge({ registration_ids: tokens })

    http = Net::HTTP.new(FCM_ENDPOINT.host, FCM_ENDPOINT.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(FCM_ENDPOINT.request_uri, initheader = {
      'Content-Type' => 'application/json',
      'Authorization' => "key=#{server_key}"
    })
    request.body = body.to_json

    response = http.request(request)

    parsed = begin
               JSON.parse(response.body)
             rescue JSON::ParserError
               response.body
             end

    success = response.code.to_i.between?(200, 299)
    { success: success, http_code: response.code.to_i, body: parsed }
  rescue StandardError => e
    { success: false, error: e.message }
  end
end
