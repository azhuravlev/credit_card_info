# frozen_string_literal: true

require_relative "providers/bincodes"
require_relative "providers/credit_card_bins"

module CreditCardInfo
  module Proxy
    # @return [Hash, NilClass] bin description
    def self.fetch(code)
      bincode_response = Providers::Bincodes.fetch(code)
      return bincode_response.data if bincode_response.valid?

      bincode_response.log_error

      card_bins_response = Providers::CreditCardBins.fetch(code)
      return card_bins_response.data if card_bins_response.valid?

      card_bins_response.log_error

      nil
    end
  end
end
