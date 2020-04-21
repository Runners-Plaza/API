class EventRenderer < Crinder::Base(Event)
  field id : Int?
  field name : String
  field english_name : String?
  field organizer : String
  field english_organizer : String?
  field location : String
  field english_location : String?
  field level : String
  field url : String?
  field status : String?
  field region : Region, with: RegionRenderer
  field start_at : String
  field sign_start_at : String?
  field sign_end_at : String?
  field iaaf : Bool
  field aims : Bool
  field measured : Bool
  field recordable : Bool
  field created_at : String
  field updated_at : String
end
