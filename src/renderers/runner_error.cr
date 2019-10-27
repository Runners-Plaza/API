class RunnerErrorRenderer < Crinder::Base(RunnerError)
  field title : String, value: title
  field description : String

  option title : String
end
