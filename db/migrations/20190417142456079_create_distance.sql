-- +micrate Up
CREATE TABLE distances (
  id BIGSERIAL PRIMARY KEY,
  event_id BIGINT,
  name VARCHAR,
  distance INT,
  cost INT,
  time_limit INT,
  runner_limit INT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX distance_event_id_idx ON distances (event_id);

-- +micrate Down
DROP TABLE IF EXISTS distances;
