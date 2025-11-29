Devise.setup do |config|
  config.mailer_sender = 'please-change-me@example.com'
  require 'devise/orm/active_record'

  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.dig(:devise, :jwt_secret_key)
    jwt.algorithm = 'HS256'
    jwt.expiration_time = 1.hour.to_i

    jwt.dispatch_requests = [
      ['POST', %r{^/auth/sign_in$}]
    ]

    jwt.revocation_requests = [
      ['DELETE', %r{^/auth/sign_out$}]
    ]

    jwt.request_formats = {
      user: [:json]
    }
  end

  config.navigational_formats = []
  config.skip_session_storage = [:http_auth, :params_auth]
end
