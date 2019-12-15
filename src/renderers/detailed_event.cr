require "./event"

class DetailedEventRenderer < EventRenderer
  field distances, with: DistanceRenderer, value: ->{ distances.to_a }
end
