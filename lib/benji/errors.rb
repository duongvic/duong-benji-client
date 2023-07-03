module Benji
    module Errors
        class ServiceError < StandardError
            def initialize(msg = nil)
                super(msg)
            end
        end

        class ServiceUnavailable < ServiceError; end

        class BadRequest < ServiceError
        end
    end
end