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
  field name : String
  field alternative_name : String
  field english_name : String
  field alternative_english_name : String
  field birthday : Time
  field phone : String
  field group_name : String
  field status_number : Int32
  field approved_at : Time
  timestamps

  def set_other_attributes(user : User? = nil, birthday : String? = nil, group : String? = nil)
    user.try { |u| self.user = u }
    birthday.try { |b| @birthday = Time.parse(b, "%F", Granite.settings.default_timezone) }
    group.try { |g| self.group = g }
    self
  end

  def group
    group_name
  end

  def group=(group : String?)
    @group_name = group
  end

  def update_status(status : String, reason : String? = nil)
    if Status.parse? status
      self.status = status
      @approved_at = Time.now
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

  def set_defaults
    self.status ||= Status::Pending
    pp! status
    pp! status_number
  end
end
