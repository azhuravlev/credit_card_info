# frozen_string_literal: true

module CreditCardInfo
  class Cache
    def self.fetch(code, &block)
      return yield unless config.provider

      config.provider.fetch("#{config.key_prefix}:#{code}", expires_in: config.ttl, &block)
    end

    def self.config
      CreditCardInfo.config.cache
    end
  end
end
