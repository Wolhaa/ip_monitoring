# frozen_string_literal: true

require 'byebug'

module IpMonitoring
  module Actions
    module IpAddress
      class Create < IpMonitoring::Action
        include Deps["repos.ip_address_repo"]

        def handle(request, response)
          validate_params(request)

          ip_address = ip_address_repo.create(request.params[:ip_address])

          response.status = 201
          response.format = :json
          response.body = ip_address.to_h.to_json
        end

        private

        def validate_params(request)
          contract = IpMonitoring::Validations::IpAddress::CreateContract.new
          validation = contract.call(request.params.to_h)
          halt 422, { errors: validation.errors.to_h }.to_json unless validation.success?
        end
      end
    end
  end
end
