class UserRenderer < Crinder::Base(User)
  field id
  field name : String
  field email : String
  field position : String
  field created_at : String
  field updated_at : String
end
