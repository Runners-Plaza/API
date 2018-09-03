require "../config/application"

unless User.first
  User.create(
    fb_id: "1792192197525041",
    name: "達人",
    email: "c910335@gmail.com",
    position_number: User::Position::Manager.value
  )
end
