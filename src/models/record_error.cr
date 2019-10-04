class RecordError < Granite::Base
  adapter pg
  table_name record_errors

  belongs_to record

  primary id : Int64
  field description : String
  timestamps
end
