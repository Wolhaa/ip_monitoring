# frozen_string_literal: true

RSpec.describe "DELETE /ip_address/:id", type: [:request, :db] do
  let(:repo) { IpMonitoring::Repos::IpAddressRepo.new }

  describe "valid requests" do
    context "when the IP exists" do
      let!(:ip_address) { repo.create(ip: Faker::Internet.ip_v4_address, enabled: true, created_at: Time.now, updated_at: Time.now) }
      let(:id) { ip_address[:id] }

      it "deletes the IP and returns success message" do
        delete "/ip_address/#{id}", {}

        expect(last_response.status).to eq(200)
        response_body = JSON.parse(last_response.body)
        expect(response_body["message"]).to eq("IP address deleted successfully")
      end
    end
  end

  describe "invalid requests" do
    context "when the IP id is not found" do
      let(:id) { 9999 }

      it "returns 404 not found" do
        delete "/ip_address/#{id}", {}

        expect(last_response.status).to eq(404)
        response_body = JSON.parse(last_response.body)
        expect(response_body["error"]).to eq("not_found")
      end
    end
  end
end
