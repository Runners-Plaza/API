-- +micrate Up
CREATE TABLE fb_tokens (
  id BIGSERIAL PRIMARY KEY,
  token VARCHAR,
  user_id VARCHAR,
  scope_string VARCHAR,
  expires_at TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX fb_token_token_idx ON fb_tokens (token);

-- +micrate Down
DROP TABLE IF EXISTS fb_tokens;
