class YouTrack::Client::Issue < YouTrack::Client::Model
  identity :id

  attribute :tags, alias: "tag", type: :array
  attribute :project, alias: "projectShortName"
  attribute :project_index, alias: "numberInProject", type: :integer
  attribute :summary
  attribute :description
  attribute :created_at, alias: "created", parser: ms_time
  attribute :updated_at, alias: "updated", parser: ms_time
  attribute :updater_username, alias: "updaterName"
  attribute :updater, alias: "updaterFullName"
  attribute :reporter_username, alias: "reporterName"
  attribute :reporter, alias: "reporterFullName"
  attribute :comment_count, alias: "commentsCount", type: :integer
  attribute :votes, type: :integer
  attribute :custom_fields, type: :array
  attribute :attachments, type: :array
  attribute :comments, type: :array
end
