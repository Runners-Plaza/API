class ApplicationController < Amber::Controller::Base
  include ErrorHelper
  include FBHelper
  include UserHelper
end
