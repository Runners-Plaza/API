class RunnerController < ApplicationController
  property! runner : Runner
  property! user : User

  before_action do
    only [:update_status, :error] { authenticate!(User::Position::Manager) }
    only [:show, :update_status, :error] { set_runner }
    only [:user_show] { authenticate!(User::Position::Manager) || set_user }
  end

  def index
    status = Runner::Status.parse(params["status"]? || "approved")
    authenticate!(User::Position::Manager).try { |e| return e } unless status.approved?
    users = current_user?.try &.position.manager?
    RunnerRenderer.render paginate(Runner.where(status_number: status.value)), user?: users, approver?: users
  end

  def show
    authenticate!(User::Position::Manager).try { |e| return e } unless runner.status.approved?
    users = current_user?.try &.position.manager?
    RunnerRenderer.render runner, user?: users, approver?: users
  end

  def user_show
    not_found! t("errors.user.runner.not_found") unless user.runner
    RunnerRenderer.render user.runner!, user?: false, approver?: true
  end

  def update_status
    if runner.update_status(params["status"], approver: current_user, reason: params["reason"]?)
      response.status_code = 204
      nil
    else
      bad_request! t("errors.runner.update")
    end
  end

  def error
    return not_found! t("errors.runner.error.not_found") unless runner.error
    RunnerErrorRenderer.render t("runner.error.title"), runner.error!
  end

  private def set_runner
    not_found! t("errors.runner.not_found", {id: params["id"]}) unless @runner = Runner.find(params["id"])
  end

  private def set_user
    not_found! t("errors.user.not_found", {id: params["id"]}) unless @user = User.find(params["id"])
  end
end
