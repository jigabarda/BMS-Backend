require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module BroadcastApi
  class Application < Rails::Application
    config.load_defaults 7.1

    config.api_only = true

    # Enable ActionCable in API mode
    require "action_cable/engine"
    config.action_cable.mount_path = "/cable"
  end
end
