class YouTrack::Client < Cistern::Service
  recognizes :logger, :adapter, :builder, :connection_options, :url, :username, :password
end

require_relative "client/real"
require_relative "client/mock"
require_relative "client/model"
require_relative "client/request"
require_relative "client/login"

models = %w(
  comment
  issue
  project
  user
)

requests = %w(
  add_project_fix_version
  apply_issue_command
  create_issue
  get_admin_user
  get_current_user
  get_issue
  get_issue_comments
  get_issues
  get_project_custom_fields
  get_projects
  remove_project_fix_version
  update_issue
)

models.each do |model|
  require_relative "client/models/#{model}"
  require_relative "client/models/#{model}s"
end

requests.each do |request|
  require_relative "client/requests/#{request}"
end
