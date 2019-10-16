class UserRenderer < Crinder::Base(User?)
  field id : Int?
  field fb_id : String, if: fb_id?
  field name : String
  field email : String
  field position : String
  field created_at : String
  field updated_at : String

  option fb_id? : Bool? = false
end
