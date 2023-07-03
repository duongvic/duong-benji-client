require 'benji/client/backup'
require 'benji/client/schedule_job'
require 'benji/client/storage'

module Benji
  module Client

    # Client API
    class APIClient
      @api = nil
      def initialize(api)
        @api = api
      end

      def backup
        Backup.new(@api)
      end

      def schedule_job
        ScheduleJob.new(@api)
      end

      def storage
        Storage.new(@api)
      end

    end
  end
end
