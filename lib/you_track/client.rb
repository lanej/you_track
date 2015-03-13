class YouTrack::Client < Cistern::Service
  recognizes :logger, :adapter, :builder, :connection_options, :url, :username, :password
end

require_relative "client/real"
require_relative "client/mock"

require_relative "client/model"
require_relative "client/request"

require_relative "client/login"
require_relative "client/get_issue"
require_relative "client/get_issues"
require_relative "client/create_issue"

require_relative "client/issue"
require_relative "client/issues"
