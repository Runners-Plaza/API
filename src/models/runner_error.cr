class RunnerError < Granite::Base
  adapter pg
  table_name runner_errors

  belongs_to runner

  primary id : Int64
  field description : String
  timestamps
end
