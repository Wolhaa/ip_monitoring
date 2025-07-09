# frozen_string_literal: true

module IpMonitoring
  module Actions
    module IpAddress
      class Stats < IpMonitoring::Action
        include Deps["repos.ip_address_repo"]

        params do
          required(:id).value(:integer)
          required(:time_from).value(:time)
          required(:time_to).value(:time)
        end

        def handle(request, response)

        end
      end
    end
  end
end
