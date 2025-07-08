# frozen_string_literal: true

module IpMonitoring
  module Relations
    class IpAddresses < IpMonitoring::DB::Relation
      schema :ip_addresses, infer: true
    end
  end
end
