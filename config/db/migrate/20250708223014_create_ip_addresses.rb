ROM::SQL.migration do
  change do
    create_table :ip_addresses do
      primary_key :id
      column :ip, :string, null: false, unique: true
      column :enabled, :boolean,  default: false
      column :created_at, :timestamp, default: Sequel::CURRENT_TIMESTAMP

      index :ip
    end
  end
end
