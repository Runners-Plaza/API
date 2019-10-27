class RecordController < ApplicationController
  property! record : Record

  before_action do
    only [:update_status] { authenticate!(User::Position::Manager) }
    only [:error] { authenticate!(User::Position::Member) }
    only [:show, :update_status, :error] { set_record }
  end

  def index
    status = Record::Status.parse(params["status"]? || "approved")
    authenticate!(User::Position::Manager).try { |e| return e } unless status.approved?
    RecordRenderer.render paginate(Record.where(status_number: status.value)), approver?: current_user?.try &.position.manager?
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

  private def set_record
    not_found! t("errors.record.not_found", {id: params["id"]}) unless @record = Record.find(params["id"])
  end
end
