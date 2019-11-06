class CurrentRecordController < ApplicationController
  CREATE_PARAMS = %w(bib_number group time chip_time rank group_rank remark)
  UPDATE_PARAMS = %w(remark)

  property! distance : Distance
  property! runner : Runner
  property! record : Record

  before_action do
    all { authenticate!(User::Position::Member) }
    only [:create] { set_runner || set_distance }
    only [:index] { set_runner }
    only [:update, :destroy] { set_runner || set_record }
  end

  def index
    RecordRenderer.render paginate(Record.where(runner_id: runner.id)), approver?: current_user.position.manager?
  end

  def create
    bad_request! t("errors.record.create") if Record.find_by(runner_id: runner.id, distance_id: distance.id)

    @record = Record.new(params.select(CREATE_PARAMS))
    record.set_other_attributes(group: params["group"]?, runner: runner, distance: distance)
    if record.save
      RecordRenderer.render record, approver?: current_user.position.manager?
    else
      bad_request! t("errors.record.create")
    end
  end

  def update
    record.set_attributes(params.select(UPDATE_PARAMS))
    if record.save
      RecordRenderer.render record, approver?: current_user.position.manager?
    else
      bad_request! t("errors.record.update")
    end
  end

  def destroy
    return forbidden!(t("errors.user.denied")) if record.status.approved?
    record.destroy
    RecordRenderer.render record, approver?: current_user.position.manager?
  end

  private def set_distance
    not_found! t("errors.distance.not_found") unless @distance = Distance.find(params["id"])
  end

  private def set_runner
    not_found! t("errors.current_runner.not_found") unless @runner = Runner.find_by(user_id: current_user.id)
  end

  private def set_record
    not_found! t("errors.record.not_found", {id: params["id"]}) unless @record = Record.find_by(id: params["id"], runner_id: runner.id)
  end
end
