class RunnerController < ApplicationController
  property! runner : Runner

  before_action do
    all { authenticate!(User::Position::Manager) }
    only [:show, :update_status, :error] { set_runner }
  end

  def index
    status = Runner::Status.parse(params["status"]? || "pending")
    RunnerRenderer.render paginate Runner.where(status_number: status.value)
  end

  def show
    RunnerRenderer.render runner
  end

  def update_status
    if runner.update_status(params["status"], reason: params["reason"]?)
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
