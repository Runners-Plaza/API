-- +micrate Up
CREATE TABLE runner_errors (
  id BIGSERIAL PRIMARY KEY,
  runner_id BIGINT,
  description VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX runner_error_runner_id_idx ON runner_errors (runner_id);

-- +micrate Down
DROP TABLE IF EXISTS runner_errors;
