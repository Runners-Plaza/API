class Runner < Granite::Base
  enum Status
    Pending
    Approved
    Rejected
  end

  connection pg
  table runners
  before_create set_defaults
  before_destroy clear_error

  belongs_to approver : User
  belongs_to user : User
  has_one error : RunnerError?
  has_many records, class_name: Record

  column id : Int64, primary: true
  column name : String?
  column alternative_name : String?
  column english_name : String?
  column alternative_english_name : String?
  column birthday : Time
  column phone : String
  column organization : String
  enum_column status : Status
  column approved_at : Time?
  timestamps

  def set_other_attributes(user : User? = nil, birthday : String? = nil)
    user.try { |u| self.user = u }
    birthday.try { |b| @birthday = Time.parse(b, "%F", Granite.settings.default_timezone) }
    self
  end

  def update_status(status : String, approver : User, reason : String? = nil)
    if Status.parse? status
      self.status = status
      @approved_at = if self.status == Status::Approved
                       Time.local
                     else
                       nil
                     end
      if self.status == Status::Rejected
        RunnerError.create(runner_id: @id, description: reason)
      else
        clear_error
      end
      self.approver = approver
      save
    end
  end

  def approver?
    @approver_id.try { self.approver }
  end

  def set_defaults
    self.status = Status::Pending unless status?
  end

  def clear_error
    error.try &.destroy
  end
end
