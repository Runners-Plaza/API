-- +micrate Up
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  fb_id VARCHAR,
  email VARCHAR,
  name VARCHAR,
  position_number INT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS users;
