# frozen_string_literal: true

module IpMonitoring
  class Routes < Hanami::Routes
     post "/ip_address", to: "ip_address.create"
  end
end
