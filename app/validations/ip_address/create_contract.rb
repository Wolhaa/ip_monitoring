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
            key.failure("IP address already exists") if IpMonitoring::Repos::IpAddressRepo.new.find_by_ip(value)
          rescue IPAddr::InvalidAddressError
            key.failure("Invalid IP address format")
          end
        end
      end
    end
  end
end
