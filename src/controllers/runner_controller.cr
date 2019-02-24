class RunnerController < ApplicationController
  property! runner : Runner

  before_action do
    only [:update_status, :error] { authenticate!(User::Position::Manager) }
    only [:show, :update_status, :error] { set_runner }
  end

  def index
    status = Runner::Status.parse(params["status"]? || "approved")
    authenticate!(User::Position::Manager).try { |e| return e } unless status == Runner::Status::Approved
    RunnerRenderer.render paginate(Runner.where(status_number: status.value)), approver?: current_user?.try &.position!.manager?
  end

  def show
    authenticate!(User::Position::Manager).try { |e| return e } unless runner.status == Runner::Status::Approved
    RunnerRenderer.render runner, approver?: current_user?.try &.position!.manager?
  end

  def update_status
    if runner.update_status(params["status"], approver: current_user, reason: params["reason"]?)
      response.status_code = 204
      nil
    else
      bad_request! t("errors.user.update")
    end
  end

  def error
    return not_found! t("errors.runner.error.not_found") unless runner.error
    RunnerErrorRenderer.render t("runner.error.title"), runner.error!
  end

  private def set_runner
    not_found! t("errors.runner.not_found", {id: params["id"]}) unless @runner = Runner.find(params["id"])
  end
end
