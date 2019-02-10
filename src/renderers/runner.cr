class RunnerRenderer < Crinder::Base(Runner)
  field id : Int?
  field name : String
  field alternative_name : String?
  field english_name : String?
  field alternative_english_name : String?
  field birthday : String, value: ->{ object.birthday.try &.to_s("%F") }
  field phone : String
  field group : String
  field status : String
  field approver, with: UserRenderer, if: ->{ object.approver_id }
  field approved_at : String?
  field created_at : String
  field updated_at : String
end