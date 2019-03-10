class UserRenderer < Crinder::Base(User?)
  class_getter? fb_id : Bool? = false

  field id : Int?
  field fb_id : String, if: fb_id?
  field name : String
  field email : String
  field position : String
  field created_at : String
  field updated_at : String

  def self.render(user, fb_id? @@fb_id = false)
    render(user)
  end
end
