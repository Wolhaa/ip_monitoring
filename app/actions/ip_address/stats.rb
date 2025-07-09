# frozen_string_literal: true

module IpMonitoring
  module Actions
    module IpAddress
      class Stats < IpMonitoring::Action
        include Deps["repos.ip_address_repo", "repos.ip_report_repo"]

        params do
          required(:id).value(:integer)
          required(:time_from).value(:time)
          required(:time_to).value(:time)
        end

        def handle(request, response)
          ip_address = ip_address_repo.find_by_id(request.params[:id])
          time_from = request.params[:time_from]
          time_to = request.params[:time_to]
          if ip_address && time_to > time_from
            stats = collect_stats(time_from, time_to, ip_address.id)
            empty_stats if stats.nil?

            response.format = :json
            response.body = stats.to_json
          else
            response.status = 422
            response.body = {error: "Invalid request parameters"}.to_json
          end
        end

        private

        def collect_stats(time_from, time_to, id)
          ip_report_repo.statistics(id, time_from, time_to)
        end
      end
    end
  end
end
