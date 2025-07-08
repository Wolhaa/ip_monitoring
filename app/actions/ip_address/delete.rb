# frozen_string_literal: true

module IpMonitoring
  module Actions
    module IpAddress
      class Delete < IpMonitoring::Action
        include Deps["repos.ip_address_repo"]

        params do
          required(:id).value(:integer)
        end

        def handle(request, response)
          ip_address = ip_address_repo.find_by_id(request.params[:id])

          if ip_address
            ip_address = ip_address_repo.delete(ip_address.id)

            response.format = :json
            response.body = { message: "IP address deleted successfully" }.to_json
          else
            response.status = 404
            response.body = {error: "not_found"}.to_json
          end
        end
      end
    end
  end
end
