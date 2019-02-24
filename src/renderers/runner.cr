class RunnerRenderer < Crinder::Base(Runner)
  class_getter? approver : Bool? = false

  field id : Int?
  field name : String
  field alternative_name : String?
  field english_name : String?
  field alternative_english_name : String?
  field birthday : String, value: ->{ birthday.try &.to_s("%F") }
  field phone : String
  field organization : String?
  field status : String
  field approver, with: UserRenderer, value: ->{ object.approver_id ? approver : nil }, if: approver?
  field approved_at : String?
  field created_at : String
  field updated_at : String

  def self.render(runner, approver? @@approver)
    render(runner)
  end
end
