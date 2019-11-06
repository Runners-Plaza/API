class FBToken < Granite::Base
  connection pg
  table fb_tokens

  column id : Int64, primary: true
  column token : String
  column user_id : String
  column scope_string : String
  column expires_at : Time
  timestamps

  def self.find_valid(token)
    if fb_token = find_by(token: token)
      if fb_token.valid?
        fb_token
      else
        fb_token.destroy
        nil
      end
    end
  end

  def scopes
    scope_string.split(' ')
  end

  def valid?
    Time.local <= expires_at
  end
end
