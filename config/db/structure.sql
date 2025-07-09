CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `ip_addresses`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `ip` string NOT NULL UNIQUE,
  `enabled` boolean DEFAULT(0),
  `created_at` timestamp DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime'))
);
CREATE INDEX `ip_addresses_ip_index` ON `ip_addresses`(`ip`);
CREATE TABLE `ip_reports`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `ip_address_id` integer NOT NULL REFERENCES `ip_addresses` ON DELETE CASCADE,
  `rtt` float NULL,
  `checked_at` timestamp DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime')) NOT NULL
);
INSERT INTO schema_migrations (filename) VALUES
('20250708223014_create_ip_addresses.rb'),
('20250709025111_create_ip_reports.rb');
