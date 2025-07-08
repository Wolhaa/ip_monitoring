CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `ip_addresses`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `ip` string NOT NULL UNIQUE,
  `enabled` boolean DEFAULT(0),
  `created_at` timestamp DEFAULT(datetime(CURRENT_TIMESTAMP, 'localtime'))
);
CREATE INDEX `ip_addresses_ip_index` ON `ip_addresses`(`ip`);
INSERT INTO schema_migrations (filename) VALUES
('20250708223014_create_ip_addresses.rb');
