class YouTrack::Client::Issue < YouTrack::Client::Model
  identity :id

  attribute :attachments, type: :array
  attribute :comment_count, alias: "commentsCount", type: :integer
  attribute :comments, type: :array
  attribute :created_at, alias: "created", parser: ms_time
  attribute :custom_fields, type: :array
  attribute :description
  attribute :project, alias: "projectShortName"
  attribute :project_index, alias: "numberInProject", type: :integer
  attribute :reporter, alias: "reporterFullName"
  attribute :reporter_username, alias: "reporterName"
  attribute :summary
  attribute :tags, alias: "tag", type: :array
  attribute :updated_at, alias: "updated", parser: ms_time
  attribute :updater, alias: "updaterFullName"
  attribute :updater_username, alias: "updaterName"
  attribute :votes, type: :integer

  attr_accessor :permitted_group

  # CREATE https://confluence.jetbrains.com/display/YTD6/Create+New+Issue
  # UPDATE https://confluence.jetbrains.com/display/YTD6/Update+an+Issue
  def save
    if new_record?
      requires :project, :summary

      merge_attributes(
        service.create_issue(
          "project"         => self.project,
          "summary"         => self.summary,
          "description"     => self.description,
          "attachments"     => self.attachments,
          "permittedGroups" => self.permitted_group,
        ).body
      )
    else
      raise NotImplementedError
    end
  end
end
