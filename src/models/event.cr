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

  connection pg
  table events

  before_destroy clear_distances

  has_many distances, class_name: Distance
  belongs_to region

  column id : Int64, primary: true
  column name : String
  column english_name : String?
  column organizer : String
  column english_organizer : String?
  column location : String
  column english_location : String?
  enum_column level : Level
  column url : String?
  column status : String?
  column start_at : Time
  column sign_start_at : Time?
  column sign_end_at : Time?
  column iaaf : Bool
  column aims : Bool
  column measured : Bool
  column recordable : Bool
  timestamps

  def set_other_attributes(args)
    self.level = args["level"] if args["level"]?
    @start_at = Time.parse(args["start_at"], "%F %T %:z", Granite.settings.default_timezone) if args["start_at"]?
    @sign_start_at = Time.parse(args["sign_start_at"], "%F %T %:z", Granite.settings.default_timezone) if args["sign_start_at"]?
    @sign_end_at = Time.parse(args["sign_end_at"], "%F %T %:z", Granite.settings.default_timezone) if args["sign_end_at"]?
    self
  end

  def clear_distances
    distances.each do |d|
      d.destroy
    end
  end
end
