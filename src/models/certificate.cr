class Certificate < Granite::Base
  adapter pg
  table_name certificates

  belongs_to record

  primary id : Int64
  field type : String
  timestamps
end
