require "shale/amber"
require "granite/adapter/pg"
require "shale/granite"

Shale.base_url = ENV["BASE_URL"]? || "http://localhost:3000"
