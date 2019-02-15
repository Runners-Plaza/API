class CurrentRunnerController < ApplicationController
  CREATE_PARAMS = %w(name alternative_name english_name alternative_english_name birthday phone organization)
  UPDATE_PARAMS = %w(phone group)

  property! runner : Runner

  before_action do
    all { authenticate!(User::Position::Member) }
    only [:show, :update, :destroy, :error] { set_runner }
  end

  def show
    CurrentRunnerRenderer.render runner
  end

  def create
    return bad_request! t("errors.runner.create") if Runner.find_by(user_id: current_user.id)

    @runner = Runner.new(params.select(CREATE_PARAMS))
    runner.set_other_attributes(user: current_user, birthday: params["birthday"]?)
    if runner.save
      CurrentRunnerRenderer.render runner
    else
      bad_request! t("errors.runner.create")
    end
  end

  def update
    return forbidden!(t("errors.user.denied")) unless runner.status == Runner::Status::Approved

    runner.set_attributes(params.select(UPDATE_PARAMS))
    if runner.save
      CurrentRunnerRenderer.render runner
    else
      bad_request! t("errors.runner.update")
    end
  end

  def destroy
    return forbidden!(t("errors.user.denied")) if runner.status == Runner::Status::Approved
    runner.destroy
    CurrentRunnerRenderer.render runner
  end

  def error
    return not_found! t("errors.runner.error.not_found") unless runner.error
    RunnerErrorRenderer.render t("runner.error.title"), runner.error!
  end

  private def set_runner
    not_found! t("errors.current_runner.not_found") unless @runner = Runner.find_by(user_id: current_user.id)
  end
end
