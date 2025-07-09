# frozen_string_literal: true

require "net/ping"

module IpMonitoring
  module Services
    class IpChecker
      def initialize(ip_address_repo, ip_report_repo)
        @ip_address_repo = ip_address_repo
        @ip_report_repo = ip_report_repo
      end

      def run
        @ip_address_repo.enabled.each do |ip|
          create_ip_check(ip)
        end
      end

      private

      def create_ip_check(ip)
        checker = Net::Ping::External.new(ip.ip.to_s)
        checker.timeout = 1
        rtt = checker.duration if checker.ping?

        @ip_report_repo.create(
          ip_address_id: ip.id,
          rtt: rtt,
          checked_at: Time.now
        )
      end
    end
  end
end
