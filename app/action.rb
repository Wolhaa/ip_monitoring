# auto_register: false
# frozen_string_literal: true

require "hanami/action"
require "dry/monads"

module IpMonitoring
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]

    def find_ip_address(id)
      ip_address_repo.find(id)
    end

    def check_params(request)
      halt 422, { errors: request.params.errors }.to_json unless request.params.valid?
    end
  end
end
