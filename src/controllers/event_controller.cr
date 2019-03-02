class EventController < ApplicationController
  PARAMS = %w(name english_name organizer english_organizer location english_location url start_at sign_start_at sign_end_at iaaf aims measured recordable)

  property! event : Event

  before_action do
    only [:create, :update, :destroy] { authenticate!(User::Position::Manager) }
    only [:show, :update, :destroy] { set_event }
  end

  def index
    EventRenderer.render paginate Event
  end

  def show
    EventRenderer.render event
  end

  def create
    @event = Event.new(params.select(PARAMS))
    event.set_other_attributes(level: params["level"]?, region: params["region"]?)
    if event.save
      EventRenderer.render event
    else
      bad_request! t("errors.event.create")
    end
  end

  def update
    event.set_attributes(params.select(PARAMS))
    if event.save
      EventRenderer.render event
    else
      bad_request! t("errors.event.update")
    end
  end

  def destroy
    event.destroy
    EventRenderer.render event
  end

  private def set_event
    not_found! t("errors.event.not_found", {"id" => params["id"]}) unless @event = Event.find_by(id: params["id"])
  end
end
