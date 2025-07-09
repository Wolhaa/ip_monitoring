# frozen_string_literal: true

RSpec.describe "POST /ip_address/:id/disable", type: [:request, :db] do
  let(:repo) { IpMonitoring::Repos::IpAddressRepo.new }

  describe "valid requests" do
    context "when the request is valid" do
      let!(:ip_address) { repo.create(ip: Faker::Internet.ip_v4_address, enabled: true, created_at: Time.now, updated_at: Time.now).to_h }
      let(:id) { ip_address[:id] }

      it "disables the IP and returns it as JSON" do
        post "/ip_address/#{id}/disable", {}

        expect(last_response.status).to eq(200)
        response_body = JSON.parse(last_response.body)
        expect(response_body["id"]).to eq(ip_address[:id])
        expect(response_body["ip"]).to eq(ip_address[:ip].to_s)
        expect(response_body["enabled"]).to eq(false)
      end
    end
  end

  describe "invalid requests" do
    context "when the IP id is not found" do
      let(:id) { 9999 }

      it "returns 404 not found" do
        post "/ip_address/#{id}/disable", {}

        expect(last_response.status).to eq(404)
        response_body = JSON.parse(last_response.body)
        expect(response_body["error"]).to eq("not_found")
      end
    end
  end
end
