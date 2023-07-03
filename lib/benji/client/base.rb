module Benji
    module Client
        class BaseApi
            def initialize(api_client)
                @api = api_client
            end

            def list(fileters = {}, page = 1, page_size = 20)
                raise NotImplementedError, "subclass did not define #list"
            end

            def get(id, fileters = {})
                raise NotImplementedError, "subclass did not define #get"
            end

            def delete(id, params = {})
                raise NotImplementedError, "subclass did not define #delete"
            end

        end
    end
end
