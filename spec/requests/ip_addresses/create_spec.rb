# frozen_string_literal: true

RSpec.describe "POST /ip_address", type: [:request, :db] do
  let(:repo) { IpMonitoring::Repos::IpAddressRepo.new }

  describe "valid requests" do
    context "when given a valid IPv4 address" do
      let(:params) do
        { ip_address: { ip: Faker::Internet.ip_v4_address, enabled: true } }
      end

      it "creates an IP" do
        post "/ip_address", params

        response = JSON.parse(last_response.body)
        expect(last_response.status).to eq(201)
        expect(response["ip"]).to eq(params[:ip_address][:ip])
        expect(response["enabled"]).to eq(params[:ip_address][:enabled])
      end
    end

    context "when given a valid IPv6 address" do
      let(:params) do
        { ip_address: { ip: Faker::Internet.ip_v6_address, enabled: true } }
      end

      it "creates an IP" do
        post "/ip_address", params

        response = JSON.parse(last_response.body)
        expect(last_response.status).to eq(201)
        expect(response["ip"]).to eq(params[:ip_address][:ip])
        expect(response["enabled"]).to eq(params[:ip_address][:enabled])
      end
    end
  end

  describe "invalid requests" do
    context "when given an invalid IP address" do
      let(:params) do
        { ip_address: { ip: "invalid_ip", enabled: true } }
      end

      it "returns 422 unprocessable entity" do
        post "/ip_address", params

        expect(last_response.status).to eq(422)
        expect(last_response.body).to include("errors")
      end
    end

    context "when given an empty IP address" do
      let(:params) do
        { ip_address: { ip: "", enabled: true } }
      end

      it "returns 422 unprocessable entity" do
        post "/ip_address", params

        expect(last_response.status).to eq(422)
        expect(last_response.body).to include("errors")
      end
    end

    context "when given a duplicate IP address" do
      let(:duplicate_ip) { Faker::Internet.ip_v4_address }
      let(:params) do
        {
          ip_address: {
            ip: duplicate_ip,
            enabled: true
          }
        }
      end

      before do
        repo.create(params[:ip_address])
      end

      it "returns 422 unprocessable entity" do
        post "/ip_address", params

        expect(last_response.status).to eq(422)
        expect(last_response.body).to include("IP address already exists")
      end
    end
  end
end
