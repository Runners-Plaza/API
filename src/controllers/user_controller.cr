class UserController < ApplicationController
  property! user : User

  before_action do
    only [:show, :update, :destroy, :runner] { set_user }
    only [:update, :destroy, :runner] { authenticate!(User::Position::Manager) }
  end

  def index
    UserRenderer.render paginate(User), fb_id?: current_user?.try &.position!.manager?
  end

  def show
    UserRenderer.render user, fb_id?: current_user?.try &.position!.manager?
  end

  def update
    user.set_attributes(user_params.validate!)
    user.position = params["position"]
    if user.valid? && user.save
      DetailedUserRenderer.render user
    else
      bad_request! t("errors.user.update")
    end
  end

  def destroy
    user.destroy
    DetailedUserRenderer.render user
  end

  def runner
    not_found! t("errors.user.runner.not_found") unless user.runner
    RunnerRenderer.render user.runner!, user?: false, approver?: true
  end

  def user_params
    params.validation do
      required(:position) { |f| !f.nil? && !!User::Position.parse?(f) }
    end
  end

  private def set_user
    not_found! t("errors.user.not_found", {id: params["id"]}) unless @user = User.find(params["id"])
  end
end
