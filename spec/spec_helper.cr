ENV["AMBER_ENV"] ||= "test"

require "spec"
require "mass_spec"
require "webmock"
require "micrate"
require "./support/*"
require "../src/*"

include MassSpec::GlobalDSL
MassSpec.configure { headers({"Origin" => "dummy"}) }

Micrate::DB.connection_url = Amber.settings.database_url
Micrate::Cli.run_up
# Granite.settings.logger = Logger.new nil
