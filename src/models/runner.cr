class Runner < Granite::Base
  enum Status
    Pending
    Approved
    Rejected
  end

  adapter pg
  table_name runners
  before_create set_defaults

  belongs_to approver : User
  belongs_to user : User
  has_one error : RunnerError
  field name : String
  field alternative_name : String
  field english_name : String
  field alternative_english_name : String
  field birthday : Time
  field phone : String
  field organization : String
  field status_number : Int32
  field approved_at : Time
  timestamps

  @status : Status? = nil

  def set_other_attributes(user : User? = nil, birthday : String? = nil)
    user.try { |u| self.user = u }
    birthday.try { |b| @birthday = Time.parse(b, "%F", Granite.settings.default_timezone) }
    self
  end

  def update_status(status : String, approver : User, reason : String? = nil)
    if Status.parse? status
      self.status = status
      @approved = if self.status == Status::Approved
                    Time.now
                  else
                    nil
                  end
      if self.status == Status::Rejected
        RunnerError.create(runner_id: @id, description: reason)
      else
        error.try &.destroy
      end
      self.approver = approver
      save
    end
  end

  def status
    @status ||= Status.from_value(status_number) if status_number
  end

  def status!
    status.not_nil!
  end

  def status=(status : Status)
    @status = status
    @status_number = status.value
  end

  def status=(number : Int)
    self.status = Status.from_value(number)
  end

  def status=(name : String)
    self.status = Status.parse(name)
  end

  def approver?
    @approver_id.try { self.approver }
  end

  def set_defaults
    self.status ||= Status::Pending
    pp! status
    pp! status_number
  end
end
