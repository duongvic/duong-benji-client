require 'benji/client/api'
require 'benji/client/client'

module Benji
    module Client
        # API Client
        # @param [Hash] options
        # @option [String] :url Server base URL.
        # @option [Hash] :credentials Authentication credentials.
        # @option [Hash] :options Options used to define connection.
        # @option [Hash] :headers Unencoded HTTP header key/value pairs.
        # @option [Hash] :request Request options.
        # @option [Hash] :ssl SSL options.
        # @option [String] :proxy Proxy url.
        def self.client(url, credentials = {}, timeout = 5, open_timeout = 2)
            api_client = Api.new(url, credentials, timeout, open_timeout)
            APIClient.new(api_client)
        end
    end
end
