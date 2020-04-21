-- +micrate Up
ALTER TABLE events ADD COLUMN status VARCHAR;

-- +micrate Down
ALTER TABLE events DROP COLUMN status;
