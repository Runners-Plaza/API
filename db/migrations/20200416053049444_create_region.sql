-- +micrate Up
CREATE TABLE regions (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR,
  english_name VARCHAR
);
ALTER TABLE events ADD COLUMN region_id BIGINT;
ALTER TABLE events DROP COLUMN region_number;

-- +micrate Down
DROP TABLE IF EXISTS regions;
ALTER TABLE events DROP COLUMN region_id;
ALTER TABLE events ADD COLUMN region_number INT;
