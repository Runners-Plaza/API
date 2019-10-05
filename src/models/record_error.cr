class RecordError < Granite::Base
  connection pg
  table record_errors

  belongs_to record

  column id : Int64, primary: true
  column description : String?
  timestamps
end
