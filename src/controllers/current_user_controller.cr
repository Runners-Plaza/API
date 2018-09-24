class CurrentUserController < ApplicationController
  before_action do
    all { authenticate!(User::Position::Member) }
  end

  def show
    UserRenderer.render current_user
  end

  def update
    user = current_user
    user.set_attributes(params.select(%w(email name)))
    if user.valid? && user.save
      UserRenderer.render user
    else
      bad_request! t("errors.user.update")
    end
  end
end
