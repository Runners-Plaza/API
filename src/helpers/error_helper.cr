module ErrorHelper
  STATUS_CODES = {
    bad_request:        400,
    forbidden:          403,
    not_found:          404,
    invalid_request:    400,
    invalid_token:      401,
    insufficient_scope: 403,
  }

  def not_found!(description : String)
    error!(:not_found, description)
  end

  def bad_request!(description : String)
    error!(:bad_request, description)
  end

  def forbidden!(description : String)
    error!(:forbidden, description)
  end

  def token_missing!(realm : String)
    auth_error!(realm, :invalid_request, t("errors.auth.token.missing"))
  end

  def token_invalid!(realm : String)
    auth_error!(realm, :invalid_token, t("errors.auth.token.invalid"))
  end

  def scope_insufficient!(realm : String)
    auth_error!(realm, :insufficient_scope, t("oauth.errors.scope.insufficient"))
  end

  def auth_error!(realm : String, type : Symbol, description : String)
    type = :invalid_request unless STATUS_CODES.has_key? type
    response.headers["WWW-Authenticate"] = auth_header(realm, type, description)
    error!(type, description)
  end

  def auth_header(realm : String, type : Symbol, description : String)
    %(Bearer realm="#{realm}", error="#{type}, error_description="#{description}")
  end

  def error!(type : Symbol, description : String)
    response.status_code = STATUS_CODES[type]
    response.content_type = "application/json"
    context.content = error_json(type, description)
  end

  def error_json(type, description)
    JSON.build do |json|
      json.object do
        json.field "error", type.to_s
        json.field "error_description", description
      end
    end
  end
end
