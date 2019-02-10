require "granite/adapter/pg"

Granite::Adapters << Granite::Adapter::Pg.new({name: "pg", url: ENV["DATABASE_URL"]? || Amber.settings.database_url})
Granite.settings.default_timezone = Time::Location.local
Granite.settings.logger = Amber.settings.logger.dup
Granite.settings.logger.not_nil!.progname = "Granite"
