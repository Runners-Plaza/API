class RunnerRenderer < Crinder::Base(Runner)
  field id
  field name : String
  field alternative_name : String
  field english_name : String
  field alternative_english_name : String
  field birthday : String
  field phone : String
  field status : String
  field approver, with: UserRenderer, if: ->{ object.approver_id }
  field approved_at : String
  field created_at : String
  field updated_at : String
end
