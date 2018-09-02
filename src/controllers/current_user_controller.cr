class CurrentUserController < ApplicationController
  before_action do
    all { authenticate!(User::Position::Member) }
  end

  def show
    UserRenderer.render current_user
  end

  def update
    user = current_user
    user.set_attributes(user_params.validate!)
    if user.valid? && user.save
      UserRenderer.render user
    else
      bad_request! t("errors.user.update")
    end
  end

  def user_params
    params.validation do
      required(:name) { |f| !f.nil? && !f.empty? }
    end
  end
end
