class Distance < Granite::Base
  adapter pg
  table_name distances

  belongs_to event

  primary id : Int64
  field name : String
  field distance : Int32
  field cost : Int32
  field time_limit : Int32
  field runner_limit : Int32
  timestamps
end
