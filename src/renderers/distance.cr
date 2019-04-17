class DistanceRenderer < Crinder::Base(Distance)
  field id : Int?
  field name : String
  field distance : Int?
  field cost : Int?
  field time_limit : Int?
  field runner_limit : Int?
  field created_at : String
  field updated_at : String
end
