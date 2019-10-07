class User < Granite::Base
  enum Position
    Member
    Manager
  end

  connection pg
  table users
  before_create set_defaults

  has_one runner : Runner

  column id : Int64, primary: true
  column fb_id : String
  column name : String
  column email : String
  enum_column position : Position
  timestamps

  def set_defaults
    self.position ||= Position::Member
  end
end
