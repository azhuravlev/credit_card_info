# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module CreditCardInfo
  module Providers
    class Bincodes
      def self.fetch(code)
        uri = URI("#{config.api_url}/bin/json/#{config.api_key}/#{code}")

        http = config.http_klass.new(uri.host, uri.port)
        http.use_ssl = true
        http.read_timeout = config.timeout

        request = Net::HTTP::Get.new(uri)
        response = http.start { |h| h.request(request) }

        parse_response(response)
      rescue StandardError => e
        CreditCardInfo::Response.new(error: { code: e.class, message: e.message })
      end

      def self.parse_response(response)
        unless response.is_a?(Net::HTTPSuccess)
          return CreditCardInfo::Response.new(error: { code:    response.code,
                                                       message: "Unexpected error from bincodes api" })
        end

        data = JSON.parse(response.body, symbolize_names: true)

        CreditCardInfo::Response.new(data: data).tap do |res|
          res.error = { code: data[:error], message: data[:message] } if data[:error]
        end
      rescue JSONError => e
        CreditCardInfo::Response.new(error: { code: e.class, message: "Invalid data from bincodes api: #{body}" })
      end

      def self.config
        CreditCardInfo.config.bincodes
      end
    end
  end
end
