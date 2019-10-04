-- +micrate Up
CREATE TABLE certificates (
  id BIGSERIAL PRIMARY KEY,
  record_id BIGINT,
  type VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX certificate_record_id_idx ON certificates (record_id);

-- +micrate Down
DROP TABLE IF EXISTS certificates;
