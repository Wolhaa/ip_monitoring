module IpMonitoring
  module Repos
    class IpAddressRepo < IpMonitoring::DB::Repo
      def create(attributes)
        ip_addresses.changeset(:create, attributes).commit
      end
    end
  end
end
