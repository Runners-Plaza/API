class UserController < ApplicationController
  before_action do
    only [:update, :destroy] { authenticate!(User::Position::Manager) }
  end

  def index
    UserRenderer.render paginate User
  end

  def show
    if user = User.find params["id"]
      UserRenderer.render user
    else
      not_found! t("errors.user.not_found", {id: params["id"]})
    end
  end

  def update
    if user = User.find(params["id"])
      user.set_attributes(user_params.validate!)
      user.position = params["position"]
      if user.valid? && user.save
        UserRenderer.render user
      else
        bad_request! t("errors.user.update")
      end
    else
      not_found! t("errors.user.not_found", {id: params["id"]})
    end
  end

  def destroy
    if user = User.find params["id"]
      user.destroy
      UserRenderer.render user
    else
      not_found! t("user.errors.not_found", {id: params["id"]})
    end
  end

  def user_params
    params.validation do
      required(:position) { |f| !f.nil? && !!User::Position.parse?(f) }
    end
  end
end
