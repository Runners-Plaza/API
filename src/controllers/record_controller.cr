class RecordController < ApplicationController
  property! record : Record

  before_action do
    only [:index] { authenticate!(User::Position::Manager) }
    only [:show] { set_record }
  end

  def index
    RecordRenderer.render paginate(Record), approver?: true
  end

  def show
    RecordRenderer.render record, approver?: current_user.position!.manager?
  end

  private def set_record
    not_found! t("errors.record.not_found", {id: params["id"]}) unless @record = Record.find(params["id"])
  end
end
