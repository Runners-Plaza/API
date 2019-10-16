class RecordErrorRenderer < Crinder::Base(RecordError)
  field title : String, value: title
  field description : String

  option title : String
end
