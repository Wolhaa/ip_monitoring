# frozen_string_literal: true

require "dry/validation"

module IpMonitoring
  module Validations
    module IpAddress
      class CreateContract < Dry::Validation::Contract
        params do
          required(:ip_address).hash do
            required(:ip).filled(:string)
            optional(:enabled).filled(:bool)
          end
        end

        rule(ip_address: :ip) do
          begin
            IPAddr.new(value)
            repo = IpMonitoring::Repos::IpAddressRepo.new
            key.failure("already exists") if repo.find_by_ip(value)
          rescue IPAddr::InvalidAddressError
            key.failure("must be a valid IPv4 or IPv6 address")
          end
        end
      end
    end
  end
end
