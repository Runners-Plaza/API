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
    get "/users/:id/runner", RunnerController, :user_show
    resources "/runners", RunnerController, only: [:index, :show]
    put "/runners/:id/status", RunnerController, :update_status
    patch "/runners/:id/status", RunnerController, :update_status
    get "/runners/:id/error", RunnerController, :error
    post "/runner", CurrentRunnerController, :create
    get "/runner", CurrentRunnerController, :show
    put "/runner", CurrentRunnerController, :update
    patch "/runner", CurrentRunnerController, :update
    delete "/runner", CurrentRunnerController, :destroy
    get "/runner/error", CurrentRunnerController, :error
    resources "/events", EventController, except: [:new, :edit]
    get "/events/:id/distances", DistanceController, :index
    post "/events/:id/distances", DistanceController, :create
    resources "/distances", DistanceController, only: [:show, :update, :destroy]
    resources "/records", RecordController, only: [:index, :show]
    post "/distances/:id/records", CurrentRecordController, :create
    get "/runner/records", CurrentRecordController, :index
    resources "/records", CurrentRecordController, only: [:update, :destroy]
    put "/records/:id/status", RecordController, :update_status
    patch "/records/:id/status", RecordController, :update_status
    get "/records/:id/error", RecordController, :error
    post "/records/:id/certificate", CertificateController, :create
    get "/records/:id/certificate", CertificateController, :show
  end
end
