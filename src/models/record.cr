class Record < Granite::Base
  enum Status
    Pending
    Approved
    Rejected
  end

  connection pg
  table records
  before_create set_defaults
  before_destroy clear_error, clear_certificate

  belongs_to runner
  belongs_to distance
  belongs_to approver : User
  has_one error : RecordError
  has_one certificate : Certificate

  column id : Int64, primary: true
  column bib_number : String
  column age_group : String?
  alias_column group, age_group
  column time : Int32
  column chip_time : Int32?
  column rank : Int32?
  column group_rank : Int32?
  column remark : String?
  enum_column status : Status
  column approved_at : Time?
  timestamps

  def set_other_attributes(group : String? = nil, runner : Runner? = nil, distance : Distance? = nil, approver : User? = nil)
    group.try { |g| self.group = g }
    runner.try { |r| self.runner = r }
    distance.try { |d| self.distance = d }
    approver.try { |a| self.approver = a }
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
        RecordError.create(record_id: @id, description: reason)
      else
        clear_error
      end
      self.approver = approver
      save
    end
  end

  def set_defaults
    self.status = Status::Pending unless status?
  end

  def clear_error
    error.try &.destroy
  end

  def clear_certificate
    certificate.try &.destroy
  end
end
