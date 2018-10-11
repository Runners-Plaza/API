Amber::Server.configure do
  pipeline :api do
    plug Amber::Pipe::PoweredByAmber.new
    plug Citrine::I18n::Handler.new
    plug Amber::Pipe::Error.new
    plug JsonHandler.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::CORS.new(
      methods: %w(GET POST PUT PATCH DELETE),
      headers: %w(Accept Content-Type Authorization),
      expose_headers: %w(Link)
    )
  end

  routes :api do
    resources "/users", UserController, except: [:new, :edit, :create]
    get "/user", CurrentUserController, :show
    put "/user", CurrentUserController, :update
    patch "/user", CurrentUserController, :update
  end
end
