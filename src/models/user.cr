class User < Granite::Base
  enum Position
    Member
    Manager
  end

  adapter pg
  table_name users
  before_create set_defaults

  has_one runner : Runner

  field fb_id : String
  field email : String
  field name : String
  enum_field position : Position
  timestamps

  def set_defaults
    self.position ||= Position::Member
  end
end
