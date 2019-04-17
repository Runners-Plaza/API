class Event < Granite::Base
  enum Level
    Activity
    Relay
    Triathlon
    LessThanTen
    TenToHalf
    Half
    Full
    Ultra
  end

  enum Region
    Northern
    Central
    Southern
    Eastern
    Other
  end

  adapter pg
  table_name events

  has_many distances : Distance

  primary id : Int64
  field name : String
  field english_name : String
  field organizer : String
  field english_organizer : String
  field location : String
  field english_location : String
  enum_field level : Level
  enum_field region : Region
  field url : String
  field start_at : Time
  field sign_start_at : Time
  field sign_end_at : Time
  field iaaf : Bool
  field aims : Bool
  field measured : Bool
  field recordable : Bool
  timestamps

  def set_other_attributes(level = nil, region = nil)
    level.try { |l| self.level = l }
    region.try { |r| self.region = r }
    self
  end
end
