class RunnerError < Granite::Base
  connection pg
  table runner_errors

  belongs_to runner

  column id : Int64, primary: true
  column description : String?
  timestamps
end
