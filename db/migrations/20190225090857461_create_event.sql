-- +micrate Up
CREATE TABLE events (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR,
  english_name VARCHAR,
  organizer VARCHAR,
  english_organizer VARCHAR,
  location VARCHAR,
  english_location VARCHAR,
  level_number INT,
  region_number INT,
  url VARCHAR,
  start_at TIMESTAMP,
  sign_start_at TIMESTAMP,
  sign_end_at TIMESTAMP,
  iaaf BOOL,
  aims BOOL,
  measured BOOL,
  recordable BOOL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS events;
