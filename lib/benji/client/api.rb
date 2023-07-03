require 'benji/errors'
require 'faraday'

module Benji
    module Client
        class Api
            include Benji::Errors
            def initialize(url, credentials = {}, timeout = 5, open_timeout = 2)
                options = {
                    :url            => url,
                    :credentials    => credentials,
                    :options        => {
                        :open_timeout => open_timeout,
                        :timeout      => timeout
                    }
                }
                @client = Faraday.new(faraday_options(options))
            rescue StandardError => err
                raise BadRequest, err.message
            end
    
            def get(url, options)
                @client.get(url, options)
            end
    
            def post(url, data)
                @client.post(url, data, {'Content-Type' => 'application/json'})
            end
    
            def put(url, data)
                @client.put(url, data,  {'Content-Type' => 'application/json'})
            end
    
            def delete(url, params)
                @client.delete(url, params,  {'Content-Type' => 'application/json'})
            end
    
            def faraday_proxy(options)
                return options[:proxy] if options[:proxy]
    
                proxy = options[:options]
                proxy[:http_proxy_uri] if proxy[:http_proxy_uri]
            end
    
            # Helper function to evalueate the low level ssl option
            def faraday_ssl(options)
                return options[:ssl] if options[:ssl]
    
                ssl = options[:options]
                return unless ssl[:verify_ssl] || ssl[:ssl_cert_store]
                {
                    verify: ssl[:verify_ssl] != OpenSSL::SSL::VERIFY_NONE,
                    cert_store: ssl[:ssl_cert_store],
                }
            end
    
            # Helper function to evalueate the low level headers option
            def faraday_headers(options)
                return options[:headers] if options[:headers]
    
                headers = options[:credentials]
                return unless headers && headers[:token]
    
                {
                    Authorization: 'Bearer ' + headers[:token].to_s,
                }
            end
    
            # Helper function to evalueate the low level headers option
            def faraday_request(options)
                return options[:request] if options[:request]
    
                request = options[:options]
                return unless request[:open_timeout] || request[:timeout]
    
                {
                    open_timeout: request[:open_timeout],
                    timeout: request[:timeout],
                }
            end
    
            # Helper function to create the args for the low level client
            def faraday_options(options)
                {
                    url: options[:url],
                    proxy: faraday_proxy(options),
                    ssl: faraday_ssl(options),
                    headers: faraday_headers(options),
                    request: faraday_request(options)
                }
            end
        end
    end
end
