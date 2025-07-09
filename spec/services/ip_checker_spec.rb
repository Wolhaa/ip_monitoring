# frozen_string_literal: true

RSpec.describe IpMonitoring::Services::IpChecker do
  let(:ip_repo) { IpMonitoring::Repos::IpAddressRepo.new }
  let(:ip_check_repo) { IpMonitoring::Repos::IpReportRepo.new }
  let(:service) { described_class.new(ip_repo, ip_check_repo) }
  let(:ip) { ip_repo.create(ip: Faker::Internet.ip_v4_address, enabled: true, created_at: Time.now, updated_at: Time.now) }

  describe "#run" do
    before do
      allow(ip_repo).to receive(:enabled).and_return([ip])
      allow(service).to receive(:create_ip_check).and_call_original
    end

    it "calls create_ip_check for enabled IP" do
      service.run

      expect(service).to have_received(:create_ip_check).with(ip)
    end
  end

  describe "#check_ip" do
    let(:checker) { instance_double("Net::Ping::External") }

    before do
      service.singleton_class.class_eval { public :create_ip_check }
      allow(Net::Ping::External).to receive(:new).with(ip.ip.to_s).and_return(checker)
      allow(checker).to receive(:timeout=).with(1)
      allow(checker).to receive(:ping?).and_return(ping_result)
      allow(checker).to receive(:duration).and_return(rtt)
    end

    context "when the IP is reachable" do
      let(:ping_result) { true }
      let(:rtt) { 0.123 }

      it "creates a check with the RTT" do
        expect(ip_check_repo).to receive(:create).with(
          ip_address_id: ip.id,
          rtt: rtt,
          checked_at: instance_of(Time)
        )

        service.create_ip_check(ip)
      end
    end

    context "when the IP is unreachable" do
      let(:ping_result) { false }
      let(:rtt) { nil }

      it "creates a check with a nil RTT" do
        expect(ip_check_repo).to receive(:create).with(
          ip_address_id: ip.id,
          rtt: nil,
          checked_at: instance_of(Time)
        )

        service.create_ip_check(ip)
      end
    end
  end
end
