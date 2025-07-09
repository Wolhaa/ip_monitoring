# frozen_string_literal: true

RSpec.describe "GET /ip_address/:id/stats", type: [:request, :db] do
  let(:ip_repo) { IpMonitoring::Repos::IpAddressRepo.new }
  let(:ip_check_repo) { IpMonitoring::Repos::IpReportRepo.new }
  let(:ip_address) { ip_repo.create(ip: Faker::Internet.ip_v4_address, enabled: true, created_at: Time.now, updated_at: Time.now) }
  let(:params) do
    { time_from: Time.now - 3600, time_to: Time.now + 3600 }
  end

  describe "valid requests" do
    context "when data is available" do
      let!(:checks) do
        checks = Array.new(3) { { ip_address_id: ip_address.id, rtt: rand(0.01..1.00), checked_at: Time.now } } +
          Array.new(2) { { ip_address_id: ip_address.id, rtt: nil, checked_at: Time.now } }
        checks.each do |check|
          ip_check_repo.create(check)
        end
        checks
      end

      let(:response) do
        successful_checks = checks.reject { |check| check[:rtt].nil? }
        failed_checks_count = checks.size - successful_checks.size

        rtt_values = successful_checks.map { |check| check[:rtt] }

        avg_rtt = rtt_values.sum / rtt_values.size.to_f
        min_rtt = rtt_values.min
        max_rtt = rtt_values.max

        sorted_rtt = rtt_values.sort
        mid_index = sorted_rtt.size / 2
        median_rtt = sorted_rtt.size.odd? ? sorted_rtt[mid_index] : (sorted_rtt[mid_index - 1] + sorted_rtt[mid_index]) / 2.0

        mean = avg_rtt
        variance = rtt_values.map { |value| (value - mean)**2 }.sum / rtt_values.size.to_f
        stddev_rtt = Math.sqrt(variance)

        total_checks = checks.size
        packet_loss_percent = (failed_checks_count.to_f / total_checks) * 100

        {
          avg_rtt: avg_rtt,
          min_rtt: min_rtt,
          max_rtt: max_rtt,
          median_rtt: median_rtt,
          stddev_rtt: stddev_rtt,
          packet_loss_percent: packet_loss_percent
        }
      end

      it "returns 200 and statistics" do
        get "/ip_address/#{ip_address.id}/stats", params

        expect(last_response.status).to eq(200)
        response_body = JSON.parse(last_response.body, symbolize_names: true)
        response_body.each do |key, value|
          expect(value).to be_within(0.000000000001).of(response[key])
        end
      end
    end
  end

  describe "invalid requests" do
    context "when parameters are missing" do
      it "returns 422 with errors" do
        get "/ip_address/#{ip_address.id}/stats", params.delete(:time_from)

        expect(last_response.status).to eq(422)
        response_body = JSON.parse(last_response.body)
      end
    end

    context "when data is unavailable" do
      let(:no_data_params) do
        { time_from: Time.now + 3600, time_to: Time.now + 4600 }
      end
      it "returns 404 with error message" do
        get "/ip_address/#{ip_address.id}/stats", no_data_params

        expect(last_response.status).to eq(404)
        expect(JSON.parse(last_response.body)).to eq({ "error" => "No data available for the given period" })
      end
    end

    context "when the request has invalid parameters" do
      let(:id) { "invalid_id" }

      it "returns 422 unprocessable entity with error details" do
        get "/ip_address/#{id}/stats", params

        expect(last_response.status).to eq(422)
        response_body = JSON.parse(last_response.body)
      end
    end

    context "when the IP id is not found" do
      let(:id) { 9999 }

      it "returns 404 not found" do
        get "/ip_address/#{id}/stats", params

        expect(last_response.status).to eq(422)
        response_body = JSON.parse(last_response.body)
        expect(response_body["error"]).to eq("Invalid request parameters")
      end
    end
  end
end
