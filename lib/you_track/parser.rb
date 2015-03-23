module YouTrack::Parser
end

require_relative "parser/base"

parsers = %w(
  comments
  issue
  issues
  project_custom_fields
  projects
  state_bundle
  user
)

parsers.each do |parser|
  require_relative "parser/#{parser}_parser"
end
