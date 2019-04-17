class DistanceController < ApplicationController
  PARAMS = %w(name distance cost time_limit runner_limit)

  property! event : Event
  property! distance : Distance

  before_action do
    only [:create, :update, :destroy] { authenticate!(User::Position::Manager) }
    only [:create, :index] { set_event }
    only [:show, :update, :destroy] { set_distance }
  end

  def index
    DistanceRenderer.render paginate Distance.where(event_id: event.id)
  end

  def show
    DistanceRenderer.render distance
  end

  def create
    @distance = Distance.new(params.select(PARAMS))
    distance.event = event
    if distance.save
      DistanceRenderer.render distance
    else
      bad_request! t("errors.distance.create")
    end
  end

  def update
    distance.set_attributes(params.select(PARAMS))
    if distance.save
      DistanceRenderer.render distance
    else
      bad_request! t("errors.distance.update")
    end
  end

  def destroy
    distance.destroy
    DistanceRenderer.render distance
  end

  private def set_event
    not_found! t("errors.event.not_found", {"id" => params["id"]}) unless @event = Event.find_by(id: params["id"])
  end

  private def set_distance
    not_found! t("errors.distance.not_found", {"id" => params["id"]}) unless @distance = Distance.find_by(id: params["id"])
  end
end
