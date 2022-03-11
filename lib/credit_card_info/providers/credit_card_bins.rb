# frozen_string_literal: true

require "credit_card_bins"

module CreditCardInfo
  module Providers
    class CreditCardBins
      def self.fetch(code)
        bin = CreditCardBin.new(code)
        CreditCardInfo::Response.new(
          data: {
            bin:         bin.bin,
            bank:        bin.issuer,
            card:        bin.brand,
            type:        bin.type,
            level:       bin.category,
            country:     bin.data.dig("country", "name"),
            countrycode: bin.data.dig("country", "alpha_2")
          }
        )
      rescue StandardError => e
        CreditCardInfo::Response.new(error: { code: e.class, message: e.message })
      end
    end
  end
end
