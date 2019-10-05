class Certificate < Granite::Base
  connection pg
  table certificates

  belongs_to record

  column id : Int64, primary: true
  column type : String
  timestamps
end
