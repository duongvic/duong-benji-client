require 'json'
require 'benji/client'
require 'benji/client/base'

module Benji
  module Client
    class ScheduleJob < BaseApi
      include Benji::Errors

      def list(filters = {}, page = 1, page_size = 20)
        options = {
          **filters,
          :page => page,
          :page_size => page_size
        }
        response = @api.get("schedule/jobs", options)
        JSON.parse(response.body)
      rescue StandardError => err
        raise BadRequest, err.message
      end

      def get(id, filters = {})
        options = {
          **filters
        }
        response = @api.get("schedule/job/#{id}", options)
        JSON.parse(response.body)
      rescue StandardError => err
        raise BadRequest, err.mes
      end

      def create(volume_id, name, mode, days_of_week, start_time, storage_name, retention, others = {})
        unless volume_id
          raise BadRequest, "volume_id cannot be nil"
        end

        unless storage_name
          raise BadRequest, "storage_name cannot be nil"
        end

        unless mode
          raise BadRequest, "mode must be either 'SNAPSHOT' or 'BACKUP'"
        end

        unless days_of_week
          raise BadRequest, "A day in the week must be specified"
        end

        unless start_time
          raise BadRequest, "start_time cannot be nil"
        end

        unless retention
          raise BadRequest, "retention cannot be nil"
        end

        body = {
          :volume_id    => volume_id,
          :name         => name,
          :mode         => mode,
          :storage_name => storage_name,
          :days_of_week => days_of_week,
          :start_time   => start_time,
          :retention    => retention,
          **others
        }

        response = @api.post("schedule/jobs", body.to_json)
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
        response = @api.delete("schedule/job/#{id}", params)
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

      def update(id, options = {})
        body = { **options }
        response = @api.put("schedule/job/#{id}", body.to_json)
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
