# frozen_string_literal: true

module IpMonitoring
  module Actions
    module IpAddress
      class Disable < IpMonitoring::Action
        include Deps["repos.ip_address_repo"]

        params do
          required(:id).value(:integer)
        end

        def handle(request, response)
          ip_address = ip_address_repo.find_by_id(request.params[:id])
          if ip_address
            ip_address = ip_address_repo.update(ip_address.id, enabled: false)

            response.format = :json
            response.body = ip_address.to_h.to_json
          else
            response.status = 404
            response.body = {error: "not_found"}.to_json
          end
        end
      end
    end
  end
end
