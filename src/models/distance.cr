class Distance < Granite::Base
  connection pg
  table distances

  belongs_to event

  column id : Int64, primary: true
  column name : String
  column distance : Int32?
  column cost : Int32?
  column time_limit : Int32?
  column runner_limit : Int32?
  timestamps
end
