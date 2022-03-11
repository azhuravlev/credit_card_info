# frozen_string_literal: true

module CreditCardInfo
  Response = Struct.new(:error, :data, keyword_init: true)
  INFO_METHODS = %i[
    bin
    bank
    card
    type
    level
    country
    countrycode
  ].freeze

  class Response
    INFO_METHODS.each do |m|
      define_method(m) { data.fetch(m, "") }
    end

    def valid?
      error.nil?
    end

    def log_error
      return unless CreditCardInfo.logger

      CreditCardInfo.logger.warn "Wrong response: error_code=#{error[:code]} error_message=#{error[:message]}"
    end
  end
end
