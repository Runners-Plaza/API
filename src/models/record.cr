class Record < Granite::Base
  enum Status
    Pending
    Approved
    Rejected
  end

  adapter pg
  table_name records
  before_create set_defaults

  belongs_to runner
  belongs_to distance
  belongs_to approver : User

  primary id : Int64
  field bib_number : String
  field age_group : String
  alias_field group, age_group
  field time : Int32
  field chip_time : Int32
  field rank : Int32
  field group_rank : Int32
  field remark : String
  enum_field status : Status
  field approved_at : Time
  timestamps

  def set_other_attributes(group : String? = nil, runner : Runner? = nil, distance : Distance? = nil, approver : User? = nil)
    group.try { |g| self.group = g }
    runner.try { |r| self.runner = r }
    distance.try { |d| self.distance = d }
    approver.try { |a| self.approver = a }
  end

  def set_defaults
    self.status ||= Status::Pending
  end
end
