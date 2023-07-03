require 'json'
require 'benji/client'
require 'benji/client/base'

module Benji
  module Client
    class Storage < BaseApi
      include Benji::Errors

      def list(filters = {}, page = 1, page_size = 20)
        options = {
          **filters,
          :page => page,
          :page_size => page_size
        }
        response = @api.get("storages", options)
        JSON.parse(response.body)
      rescue StandardError => err
        raise BadRequest, err.message
      end

      def get(id, filters = {})
        options = {
          **filters
        }
        response = @api.get("storage/#{id}", options)
        JSON.parse(response.body)
      rescue StandardError => err
        raise BadRequest, err.message
      end

      def create(name, disk_used, disk_allowed, others = {})
        unless name
          raise BadRequest, "Storage name cannot be nil"
        end

        unless disk_used
          raise BadRequest, "Disk used cannot be nil"
        end

        unless disk_allowed
          raise BadRequest, "Disk allowed used cannot be nil"
        end

        body = {
          :name         => name,
          :disk_used    => disk_used,
          :disk_allowed => disk_allowed,
          **others
        }

        response = @api.post("storages", body.to_json)
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

      def update(id, disk_used, disk_allowed, others = {})
        body = {
          :disk_used      => disk_used,
          :disk_allowed   => disk_allowed,
          **others
        }
        response = @api.put("storage/#{id}", body.to_json)
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

      def delete(id, wait = false, force = true)
        params = {
          "force": force
        }
        response = @api.delete("storage/#{id}", params)
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
