module IpMonitoring
  module Repos
    class IpAddressRepo < IpMonitoring::DB::Repo
      def create(attributes)
        puts attributes
        ip_addresses.changeset(:create, attributes).commit
      end

      def find_by_ip(ip)
        ip_addresses.where(ip: ip).one
      end
    end
  end
end
