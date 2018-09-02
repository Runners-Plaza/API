Amber::Server.configure do
  pipeline :api do
    plug Amber::Pipe::PoweredByAmber.new
    plug Citrine::I18n::Handler.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::CORS.new(methods: %w(GET POST PUT PATCH DELETE), headers: %w(Accept Content-Type Authorization))
  end

  routes :api do
  end
end
