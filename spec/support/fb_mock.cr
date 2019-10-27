module MANAGER
  TOKEN_INFO = {
    "data" => {
      "app_id"                 => "app_id",
      "type"                   => "USER",
      "application"            => "Runners' Plaza",
      "data_access_expires_at" => (Time.local + 3.months).to_unix,
      "expires_at"             => (Time.local + 2.hours).to_unix,
      "is_valid"               => true,
      "scopes"                 => [
        "email",
        "public_profile",
      ],
      "user_id": "manager",
    },
  }.to_json

  FB_USER = {
    "name"  => "Manager",
    "email" => "manager@bar.com",
    "id"    => "manager",
  }.to_json
end

module MEMBER
  TOKEN_INFO = {
    "data" => {
      "app_id"                 => "app_id",
      "type"                   => "USER",
      "application"            => "Runners' Plaza",
      "data_access_expires_at" => (Time.local + 3.months).to_unix,
      "expires_at"             => (Time.local + 2.hours).to_unix,
      "is_valid"               => true,
      "scopes"                 => [
        "email",
        "public_profile",
      ],
      "user_id" => "member",
    },
  }.to_json

  FB_USER = {
    "name"  => "Member",
    "email" => "member@foo.com",
    "id"    => "member",
  }.to_json
end

WebMock.stub(:get, "fakefb.mock/debug_token")
  .with(query: {"input_token" => "manager_token"})
  .to_return(body: MANAGER::TOKEN_INFO)
WebMock.stub(:get, "fakefb.mock/debug_token")
  .with(query: {"input_token" => "member_token"})
  .to_return(body: MEMBER::TOKEN_INFO)
WebMock.stub(:get, "fakefb.mock/v3.1/me")
  .with(headers: {"Authorization" => "Bearer manager_token"})
  .to_return(body: MANAGER::FB_USER)
WebMock.stub(:get, "fakefb.mock/v3.1/me")
  .with(headers: {"Authorization" => "Bearer member_token"})
  .to_return(body: MEMBER::FB_USER)
