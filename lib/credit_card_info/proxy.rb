# frozen_string_literal: true

require_relative "providers/bincodes"
require_relative "providers/binlist"
require_relative "providers/credit_card_bins"

module CreditCardInfo
  module Proxy
    # @return [Hash, NilClass] bin description
    def self.fetch(code)
      providers.each do |provider|
        response = provider.fetch(code)
        return response.data if response.valid?

        response.log_error
      end

      nil
    end

    def self.providers
      @providers ||=
        CreditCardInfo.config.data_providers.filter_map do |name|
          Object.const_get "CreditCardInfo::Providers::#{name}"
        rescue NameError
          nil
        end
    end
  end
end
