class CurrentUserController < ApplicationController
  before_action do
    all { authenticate!(User::Position::Member) }
  end

  def show
    DetailedUserRenderer.render current_user
  end

  def update
    current_user.set_attributes(params.select(%w(email name)))
    if current_user.valid? && current_user.save
      DetailedUserRenderer.render current_user
    else
      bad_request! t("errors.user.update")
    end
  end
end
