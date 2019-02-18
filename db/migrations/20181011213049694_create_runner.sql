-- +micrate Up
CREATE TABLE runners (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT,
  name VARCHAR,
  alternative_name VARCHAR,
  english_name VARCHAR,
  alternative_english_name VARCHAR,
  birthday DATE,
  phone VARCHAR,
  organization VARCHAR,
  status_number INT,
  approver_id BIGINT,
  approved_at TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX runner_approver_id_idx ON runners (approver_id);
CREATE INDEX runner_user_id_idx ON runners (user_id);

-- +micrate Down
DROP TABLE IF EXISTS runners;
