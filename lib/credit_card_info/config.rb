# frozen_string_literal: true

require "logger"
require "dry-configurable"

module CreditCardInfo
  class Config
    extend Dry::Configurable

    setting :bincodes do
      setting :api_key, default: ""
      setting :api_url, default: "https://api.bincodes.com"
      setting :timeout, default: 10
      setting :http_klass, default: Net::HTTP
    end

    setting :cache do
      setting :provider, default: defined?(Rails) ? Rails.cache : nil
      setting :ttl, default: 2678400 # 31 days
      setting :key_prefix, default: "ccinfo"
    end

    setting :logger, default: defined?(Rails) ? Rails.logger : Logger.new($stdout)
  end
end
