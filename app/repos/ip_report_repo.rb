# frozen_string_literal: true

module IpMonitoring
  module Repos
    class IpReportRepo < IpMonitoring::DB::Repo
      commands :create

      def statistics(ip_id, time_from, time_to)
        query = <<-SQL
          WITH stats AS (
            SELECT
              AVG(rtt) AS avg_rtt,
              MIN(rtt) AS min_rtt,
              MAX(rtt) AS max_rtt,
              PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rtt) AS median_rtt,
              STDDEV_POP(rtt) AS stddev_rtt,
              COUNT(*) AS total_checks,
              SUM(CASE WHEN rtt IS NULL THEN 1 ELSE 0 END) AS failed_checks
            FROM ip_reports
            WHERE ip_id = ?
              AND checked_at BETWEEN ? AND ?
          )
          SELECT
            avg_rtt,
            min_rtt,
            max_rtt,
            median_rtt,
            stddev_rtt,
            total_checks,
            (failed_checks::float / total_checks::float) * 100 AS packet_loss_percent
          FROM stats;
        SQL

        result = ip_reports.dataset.with_sql(query, ip_id, time_from, time_to).first
        return nil if result.nil? || result[:total_checks].to_i.zero?

        result.delete(:total_checks)
        result
      end
    end
  end
end
