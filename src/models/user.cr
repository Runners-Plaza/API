class User < Granite::Base
  enum Position
    Member
    Manager
  end

  adapter pg
  table_name users
  before_create set_defaults

  field fb_id : String
  field email : String
  field name : String
  field position_number : Int32
  timestamps

  def position
    @position ||= Position.from_value(position_number) if position_number
  end

  def position!
    position.not_nil!
  end

  def position=(position : Position)
    @position = position
    @position_number = position.value
  end

  def position=(number : Int)
    self.position = Position.from_value(number)
  end

  def position=(name : String)
    self.position = Position.parse(name)
  end

  def set_defaults
    self.position ||= Position::Member
  end
end
