# config/initializers/fcm.rb
require 'fcm'
fcm_key = ENV['FCM_SERVER_KEY'] || Rails.application.credentials.dig(:fcm, :server_key)
FCM_CLIENT = FCM.new(fcm_key)
