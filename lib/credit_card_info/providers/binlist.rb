# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

# {
#   "number": {
#     "length": 16,
#     "luhn": true
#   },
#   "scheme": "visa",
#   "type": "debit",
#   "brand": "Visa/Dankort",
#   "prepaid": false,
#   "country": {
#     "numeric": "208",
#     "alpha2": "DK",
#     "name": "Denmark",
#     "emoji": "🇩🇰",
#     "currency": "DKK",
#     "latitude": 56,
#     "longitude": 10
#   },
#   "bank": {
#     "name": "Jyske Bank",
#     "url": "www.jyskebank.dk",
#     "phone": "+4589893300",
#     "city": "Hjørring"
#   }
# }
module CreditCardInfo
  module Providers
    class Binlist
      API_VERSION = "3"

      def self.fetch(code)
        uri = URI.join(config.api_url, "/#{code}")

        http = config.http_klass.new(uri.host, uri.port)
        http.use_ssl = true
        http.read_timeout = config.timeout

        request = Net::HTTP::Get.new(uri, { "Accept-Version" => API_VERSION })
        response = http.start { |h| h.request(request) }

        parse_response(code, response)
      rescue StandardError => e
        CreditCardInfo::Response.new(error: { code: e.class, message: e.message })
      end

      def self.parse_response(code, response)
        unless response.is_a?(Net::HTTPSuccess)
          return CreditCardInfo::Response.new(error: { code:    response.code,
                                                       message: "Unexpected error from binlist api" })
        end

        data = JSON.parse(response.body, symbolize_names: true)

        CreditCardInfo::Response.new(data: transform_keys(code, data))
      rescue StandardError => e
        CreditCardInfo::Response.new(error: { code:    e.class,
                                              message: "Invalid data from binlist api: #{response.body}" })
      end

      def self.transform_keys(code, data)
        {
          bin:         code,
          bank:        data.dig(:bank, :name),
          card:        data[:scheme],
          type:        data[:type],
          level:       data[:brand],
          country:     data.dig(:country, :name),
          countrycode: data.dig(:country, :alpha2)
        }
      end

      def self.config
        CreditCardInfo.config.binlist
      end
    end
  end
end
