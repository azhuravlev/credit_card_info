# frozen_string_literal: true

require "credit_card_info/proxy"
require "credit_card_info/cache"
require "credit_card_info/config"
require "credit_card_info/response"
require "credit_card_info/version"

module CreditCardInfo
  class Error < StandardError; end

  def self.config
    @config ||= Config.config
  end

  def self.fetch(value)
    code = extract_bin(value)
    Cache.fetch(code) { Proxy.fetch(code) }
  end

  def self.logger
    @logger ||= config.logger
  end

  # @return [String] first 5 digits of credit card number i.e. BIN
  def self.extract_bin(value)
    value.to_s.delete("\s")[0..5]
  end
end
