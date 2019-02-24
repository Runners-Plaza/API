module UserHelper
  @current_user : User?

  def current_user
    current_user?.not_nil!
  end

  def current_user?
    @current_user ||= find_or_create_user
  end

  def find_or_create_user
    return nil unless token_data?
    if user = User.find_by(fb_id: token_data.user_id)
      user
    else
      User.create(fb_id: fb_user.id, name: fb_user.name, email: fb_user.email)
    end
  end

  def authenticate!(position : User::Position)
    fb_authenticate!.try { |e| return e }
    return forbidden!(t("errors.user.denied")) unless current_user.position! >= position
    nil
  end
end
