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
    return token_invalid!(REALM) unless token_info? && token_data.valid?
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
                      if fb_token = FBToken.find_valid(token_string)
                        TokenInfo.new(fb_token)
                      else
                        response = HTTP::Client.get("#{base_url}/debug_token?input_token=#{token_string}", headers: HTTP::Headers{"Authorization" => "Bearer #{client_token}"})
                        if response.success? && (info = TokenInfo.from_json(response.body))
                          FBToken.create(token: token_string, scope_string: info.data.scopes.join(' '), user_id: info.data.user_id, expires_at: info.data.expires_at)
                          info
                        end
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
        user_id: String,
        scopes: Array(String),
        expires_at: {type: Time, converter: Time::EpochConverter},
        is_valid: Bool
      )

      def initialize(@user_id, @scopes, @expires_at, @is_valid)
      end

      def valid?
        is_valid
      end
    end

    def initialize(fb_token : FBToken)
      @data = Data.new(fb_token.user_id, fb_token.scopes, fb_token.expires_at, fb_token.valid?)
    end
  end
end
