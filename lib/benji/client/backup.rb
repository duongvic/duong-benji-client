require 'json'
require 'benji/client'
require 'benji/client/base'

module Benji
    module Client
        # Backup service
        class Backup < BaseApi
            include Benji::Errors

            def list(filters = {}, page = 1, page_size = 20)
                options = {
                    **filters,
                    :page => page,
                    :page_size => page_size
                }
                response = @api.get("versions", options)
                JSON.parse(response.body)
            rescue StandardError => err
                raise BadRequest, err.message
            end

            def get(id, filters = {})
                options = {
                  **filters
                }
                response = @api.get("version/#{id}", options)
                JSON.parse(response.body)
            rescue StandardError => err
                raise BadRequest, err.message
            end

            def create(volume_id, storage_name, others = {})
                unless volume_id
                    raise BadRequest, 'volume_id is not nil'
                end

                unless storage_name
                    raise BadRequest, 'volume_id is not nil'
                end

                body = {
                    volume_id: volume_id,
                    storage_name: storage_name,
                    **others
                }
                response = @api.post("versions", body.to_json)
                body = JSON.parse(response.body)
                if response.status != 201
                    errors = body['errors']
                    raise BadRequest, errors[0]['message']
                else
                    if body.nil?
                        response.status
                    else
                        body
                    end
                end
            rescue StandardError => err
                raise BadRequest, err.message
            end

            def restore(id, wait = false, force = true)
                params = {
                  force: force,
                  wait: wait
                }
                response = @api.post("version/#{id}", params.to_json)
                body = JSON.parse(response.body)
                if response.status != 200
                    errors = body['error']
                    raise BadRequest, errors
                else
                    if body.nil?
                        response.status
                    else
                        body
                    end
                end
            end

            def delete(id, wait = false, force = true)
                params = {
                  "force": force,
                  "wait": wait
                }
                response = @api.delete("version/#{id}", params)
                body = JSON.parse(response.body)
                if response.status != 200
                    errors = body['errors']
                    raise BadRequest, errors[0]['message']
                else
                    if body.nil?
                        response.status
                    else
                        body
                    end
                end
            rescue StandardError => err
                raise BadRequest, err.message
            end
        end
    end
end
