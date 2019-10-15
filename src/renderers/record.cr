class RecordRenderer < Crinder::Base(Record)
  class_getter? approver : Bool? = false

  field id : Int?
  field runner, with: RunnerRenderer
  field event, with: EventRenderer, value: ->{ distance.event }
  field distance, with: DistanceRenderer
  field bib_number : String
  field group : String?
  field time : Int
  field chip_time : Int?
  field rank : Int?
  field group_rank : Int?
  field remark : String?
  field status : String
  field approver, with: UserRenderer, value: ->{ object.approver_id.try { approver } }, if: approver?
  field approved_at : String?
  field updated_at : String
  field created_at : String

  def self.render(record, approver? @@approver = false)
    render(record)
  end
end
