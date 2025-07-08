# frozen_string_literal: true

module IpMonitoring
  module Actions
    module IpAddress
      class Creat < IpMonitoring::Action
        include Deps["repos.ip_address_repo"]

        params do
          required(:ip_address).hash do
            required(:ip).filled(:string)
            required(:enabled).filled(:boolean)
          end
        end
        def handle(request, response)

        end
      end
    end
  end
end
