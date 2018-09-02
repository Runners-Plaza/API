module FBHelper
  REALM  = "Facebook"
  SCOPES = ["public_profile", "email"]

  @@base_url : String?
  @@client_token : String?
  @token_info : TokenInfo?
  @token_string : String?
  @token_scopes : Array(String)?

  forward_missing_to FBHelper

  def self.config(key : String)
    Amber.settings.secrets.try(&.[key]).not_nil!
  end

  def self.base_url
    @@base_url ||= config "fb_base_url"
  end

  def self.client_token
    @@client_token ||= config "fb_client_token"
  end

  def fb_authenticate!
    return token_missing!(REALM) && nil unless token_string
    return token_invalid!(REALM) && nil unless token_info? && token_info.data.is_valid
    return scope_insufficient!(REALM) && nil unless (token_scopes & SCOPES).size == SCOPES.size
    token_info.data
  end

  def token_info : TokenInfo
    token_info?.not_nil!
  end

  def token_scopes : Array(String)
    @token_scopes ||= token_info.data.scopes
  end

  def token_info? : TokenInfo | Nil
    @token_info ||= HTTP::Client.get("#{base_url}/debug_token?input_token=#{token_string}", headers: HTTP::Headers{"Authorization" => "Bearer #{client_token}"}) do |response|
      if response.success?
        TokenInfo.from_json(response.body_io)
      end
    end
  end

  def token_string : String | Nil
    @token_string ||= (authorization = request.headers["Authorization"]?) && authorization[/Bearer (.*)$/, 1]?
  end

  class TokenInfo
    JSON.mapping(
      data: Data
    )

    class Data
      JSON.mapping(
        app_id: String,
        type: String,
        application: String,
        expires_at: {type: Time, converter: Time::EpochConverter},
        is_valid: Bool,
        scopes: Array(String),
        user_id: String
      )
    end
  end
end
