class RecordErrorRenderer < Crinder::Base(RecordError)
  @@title : String?

  field title : String, value: @@title
  field description : String

  def self.render(@@title, error : RecordError)
    render(error)
  end
end
