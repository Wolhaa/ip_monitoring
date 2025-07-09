require "rufus-scheduler"
require "./lib/ip_monitoring/services/ip_checker"

scheduler = Rufus::Scheduler.new

scheduler.every "10m" do
  ip_address_repo = IpMonitoring::Repos::IpAddressRepo.new
  ip_report_repo = IpMonitoring::Repos::IpReportRepo.new
  IpMonitoring::Services::IpChecker.new(ip_address_repo, ip_report_repo).run
end

scheduler.join
