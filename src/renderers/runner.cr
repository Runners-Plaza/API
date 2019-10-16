class RunnerRenderer < Crinder::Base(Runner)
  field id : Int?
  field user, with: DetailedUserRenderer, value: ->{ object.user_id.try { user } }, if: user?
  field name : String
  field alternative_name : String?
  field english_name : String?
  field alternative_english_name : String?
  field birthday : String, value: ->{ birthday.try &.to_s("%F") }
  field phone : String
  field organization : String?
  field status : String
  field approver, with: UserRenderer, value: ->{ object.approver_id.try { approver } }, if: approver?
  field approved_at : String?
  field created_at : String
  field updated_at : String

  option user? : Bool? = false
  option approver? : Bool? = false
end
