class EventController < ApplicationController
  PARAMS       = %w(name english_name organizer english_organizer location english_location url status region_id iaaf aims measured recordable)
  OTHER_PARAMS = %w(level start_at sign_start_at sign_end_at)

  property! event : Event
  property! region : Region

  before_action do
    only [:create] { authenticate!(User::Position::Manager) || set_region }
    only [:show] { set_event }
    only [:update] { authenticate!(User::Position::Manager) || set_event || set_region? }
    only [:destroy] { authenticate!(User::Position::Manager) || set_event }
  end

  def index
    DetailedEventRenderer.render paginate Event
  end

  def show
    DetailedEventRenderer.render event
  end

  def create
    @event = Event.new(params.select(PARAMS))
    event.set_other_attributes(params.select(OTHER_PARAMS))
    if event.save
      DetailedEventRenderer.render event
    else
      bad_request! t("errors.event.create")
    end
  end

  def update
    event.set_attributes(params.select(PARAMS))
    event.set_other_attributes(params.select(OTHER_PARAMS))
    if event.save
      DetailedEventRenderer.render event
    else
      bad_request! t("errors.event.update")
    end
  end

  def destroy
    event.destroy
    DetailedEventRenderer.render event
  end

  private def set_event
    not_found! t("errors.event.not_found", {"id" => params["id"]}) unless @event = Event.find_by(id: params["id"])
  end

  private def set_region
    not_found! t("errors.region.not_found", {"id" => params["region_id"]}) unless params["region_id"]? && (@region = Region.find_by(id: params["region_id"]))
  end

  private def set_region?
    not_found! t("errors.region.not_found", {"id" => params["region_id"]}) if params["region_id"]? && !(@region = Region.find_by(id: params["region_id"]))
  end
end
