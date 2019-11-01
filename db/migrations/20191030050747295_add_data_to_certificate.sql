-- +micrate Up
ALTER TABLE certificates ADD COLUMN data BYTEA;
ALTER TABLE certificates DROP COLUMN type;

-- +micrate Down
ALTER TABLE certificates DROP COLUMN data;
ALTER TABLE certificates ADD COLUMN type VARCHAR;
