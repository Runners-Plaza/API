class RecordController < ApplicationController
  property! record : Record
  property! runner : Runner
  property! event : Event

  before_action do
    only [:update_status] { authenticate!(User::Position::Manager) || set_record }
    only [:error] { authenticate!(User::Position::Member) || set_record }
    only [:show] { set_record }
    only [:runner_index] { set_runner }
  end

  def index
    status = Record::Status.parse(params["status"]? || "approved")
    authenticate!(User::Position::Manager).try { |e| return e } unless status.approved?
    records = if event_id = params["event_id"]?
                return not_found! t("errors.event.not_found") unless @event = Event.find(event_id)
                distances = event.distances.to_a
                if distances.empty?
                  Record.limit(0)
                else
                  Record.where(distance_id: distances.map &.id!)
                end
              else
                Record
              end
    RecordRenderer.render paginate(records.where(status_number: status.value)), approver?: current_user?.try &.position.manager?
  end

  def runner_index
    RecordRenderer.render paginate(Record.where(runner_id: runner.id, status_number: Record::Status::Approved.value)), approver?: current_user?.try &.position.manager?
  end

  def show
    authenticate!(User::Position::Manager).try { |e| return e } unless record.status.approved? || current_user?.try &.id == record.runner.user_id
    RecordRenderer.render record, approver?: current_user?.try &.position.manager?
  end

  def update_status
    if record.update_status(params["status"], approver: current_user, reason: params["reason"]?)
      response.status_code = 204
      nil
    else
      bad_request! t("errors.user.update")
    end
  end

  def error
    authenticate!(User::Position::Manager).try { |e| return e } unless current_user.id == record.runner.user_id
    return not_found! t("errors.record.error.not_found") unless record.error
    RecordErrorRenderer.render record.error!, title: t("record.error.title")
  end

  private def set_runner
    not_found! t("errors.runner.not_found", {id: params["id"]}) unless @runner = Runner.find(params["id"])
  end

  private def set_record
    not_found! t("errors.record.not_found", {id: params["id"]}) unless @record = Record.find(params["id"])
  end
end
