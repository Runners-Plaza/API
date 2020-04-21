class Region < Granite::Base
  connection pg
  table regions

  column id : Int64, primary: true
  column name : String
  column english_name : String
end
