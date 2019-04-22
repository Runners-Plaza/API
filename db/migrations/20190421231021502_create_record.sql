-- +micrate Up
CREATE TABLE records (
  id BIGSERIAL PRIMARY KEY,
  runner_id BIGINT,
  distance_id BIGINT,
  bib_number VARCHAR,
  age_group VARCHAR,
  time INT,
  chip_time INT,
  rank INT,
  group_rank INT,
  remark VARCHAR,
  status_number INT,
  approver_id BIGINT,
  approved_at TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX record_runner_id_idx ON records (runner_id);
CREATE INDEX record_distance_id_idx ON records (distance_id);
CREATE INDEX record_approver_id_idx ON records (approver_id);

-- +micrate Down
DROP TABLE IF EXISTS records;
