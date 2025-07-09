# frozen_string_literal: true

module IpMonitoring
  module Relations
    class IpReports < IpMonitoring::DB::Relation
      schema :ip_reports, infer: true
    end
  end
end
