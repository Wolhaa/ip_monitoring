# frozen_string_literal: true

module IpMonitoring
  class Routes < Hanami::Routes
     post "/ip_address", to: "ip_address.create"
     post "/ip_address/:id/enable", to: "ip_address.enable"
     post "/ip_address/:id/disable", to: "ip_address.disable"
  end
end
