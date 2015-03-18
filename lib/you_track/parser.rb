module YouTrack::Parser
end

require_relative "parser/base"

parsers = %w(
  comments
  issue
  issues
  projects
  user
  project_custom_fields
)

parsers.each do |parser|
  require_relative "parser/#{parser}_parser"
end
