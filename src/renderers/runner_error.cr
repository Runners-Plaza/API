class RunnerErrorRenderer < Crinder::Base(RunnerError)
  @@title : String?

  field title : String, value: @@title
  field description : String

  def self.render(@@title, error : RunnerError)
    render(error)
  end
end
