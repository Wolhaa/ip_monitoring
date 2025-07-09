# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :ip_reports do
      primary_key :id
      foreign_key :ip_address_id, :ip_addresses, on_delete: :cascade, null: false
      column :rtt, :float, null: true
      column :checked_at, :timestamp, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
