-- +micrate Up
CREATE TABLE record_errors (
  id BIGSERIAL PRIMARY KEY,
  record_id BIGINT,
  description VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX record_error_record_id_idx ON record_errors (record_id);

-- +micrate Down
DROP TABLE IF EXISTS record_errors;
