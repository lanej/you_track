class YouTrack::Client < Cistern::Service
  requires :url, :username, :password
  recognizes :logger, :adapter, :builder, :connection_options
end

require_relative "client/real"
require_relative "client/mock"

require_relative "client/model"

require_relative "client/login"
require_relative "client/get_issue"

require_relative "client/issue"
require_relative "client/issues"
