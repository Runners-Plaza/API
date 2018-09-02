module FBHelper
  REALM  = "Facebook"
  SCOPES = ["public_profile", "email"]

  @@base_url : String?
  @@client_token : String?
  @token_info : TokenInfo?
  @token_string : String?
  @token_scopes : Array(String)?
  @fb_user : FBUser?

  forward_missing_to FBHelper

  def self.config(key : String) : String
    Amber.settings.secrets.try(&.[key]).not_nil!
  end

  def self.base_url : String
    @@base_url ||= config "fb_base_url"
  end

  def self.client_token : String
    @@client_token ||= config "fb_client_token"
  end

  def fb_authenticate! : TokenInfo::Data | Nil
    token_missing!(REALM) || return unless token_string
    token_invalid!(REALM) || return unless token_info? && token_data.is_valid
    scope_insufficient!(REALM) || return unless (token_scopes & SCOPES).size == SCOPES.size
    token_data
  end

  def fb_user : FBUser
    fb_user?.not_nil!
  end

  def fb_user? : FBUser | Nil
    @fb_user ||= HTTP::Client.get("#{base_url}/v3.1/me?fields=name,email", headers: HTTP::Headers{"Authorization" => "Bearer #{token_string}"}) do |response|
      if response.success?
        FBUser.from_json(response.body_io)
      end
    end
  end

  def token_scopes : Array(String)
    @token_scopes ||= token_data.scopes
  end

  def token_data : TokenInfo::Data
    token_info?.not_nil!.data
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

  class FBUser
    JSON.mapping(
      id: String,
      name: String,
      email: String
    )
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
