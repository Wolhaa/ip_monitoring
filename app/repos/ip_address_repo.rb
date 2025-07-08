module IpMonitoring
  module Repos
    class IpAddressRepo < IpMonitoring::DB::Repo
      commands :create, update: :by_pk, delete: :by_pk

      def find_by_ip(ip)
        ip_addresses.where(ip: ip).first
      end

      def find_by_id(id)
        ip_addresses.by_pk(id).one
      end
    end
  end
end
