module FBHelper
  REALM  = "Facebook"
  SCOPES = ["public_profile", "email"]

  @@base_url : String?
  @@client_token : String?
  @token_info : TokenInfo?
  @token_string : String?
  @token_scopes : Array(String)?
  @fb_user : FBUser?

  delegate config, base_url, client_token, to: FBHelper

  def self.config(key : String) : String
    Amber.settings.secrets.try(&.[key]).not_nil!
  end

  def self.base_url : String
    @@base_url ||= config "fb_base_url"
  end

  def self.client_token : String
    @@client_token ||= config "fb_client_token"
  end

  def fb_authenticate! : String?
    return token_missing!(REALM) unless token_string
    return token_invalid!(REALM) unless token_info? && token_data.is_valid
    return scope_insufficient!(REALM) unless (token_scopes & SCOPES).size == SCOPES.size
    nil
  end

  def fb_user : FBUser
    fb_user?.not_nil!
  end

  def fb_user? : FBUser?
    response = HTTP::Client.get("#{base_url}/v3.1/me?fields=name,email", headers: HTTP::Headers{"Authorization" => "Bearer #{token_string}"})
    @fb_user ||= if response.success?
                   FBUser.from_json(response.body)
                 end
  end

  def token_scopes : Array(String)
    @token_scopes ||= token_data.scopes
  end

  def token_data : TokenInfo::Data
    token_data?.not_nil!
  end

  def token_data? : TokenInfo::Data?
    token_info?.try &.data
  end

  def token_info? : TokenInfo?
    @token_info ||= if token_string
                      response = HTTP::Client.get("#{base_url}/debug_token?input_token=#{token_string}", headers: HTTP::Headers{"Authorization" => "Bearer #{client_token}"})
                      if response.success?
                        TokenInfo.from_json(response.body)
                      else
                        nil
                      end
                    end
  end

  def token_string : String?
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
