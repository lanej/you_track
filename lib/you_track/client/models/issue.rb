class YouTrack::Client::Issue < YouTrack::Client::Model
  identity :id

  attribute :attachments, type: :array
  attribute :comment_count, alias: "commentsCount", type: :integer
  attribute :comments, type: :array
  attribute :created_at, alias: "created", parser: ms_time
  attribute :custom_fields, default: [], parser: lambda { |v, _| Hash[v] }
  attribute :description
  attribute :project_id, alias: "projectShortName"
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

  def comments
    service.comments.load(service.get_issue_comments(self.identity).body)
  end

  def comment(comment)
    service.apply_issue_command("id" => self.identity, "comment" => comment)
    comments.detect { |c| c.text == comment }
  end

  def state
    custom_fields["State"]
  end

  def state=(new_state)
    service.apply_issue_command("id" => self.identity, "command" => "State #{new_state}")
    self.reload
  end

  def project=(project)
    self.project_id = (project.is_a?(YouTrack::Client::Project) ? project.identity : project)
  end

  def project
    requires :project_id

    service.projects.get(self.project_id)
  end

  def save
    if new_record?
      if collection
        self.project_id ||= collection.project_id
      end

      requires :summary, :project_id

      response = service.create_issue(
        "project"         => self.project_id,
        "summary"         => self.summary,
        "description"     => self.description,
        "attachments"     => self.attachments,
        "permittedGroups" => self.permitted_group,
      )

      merge_attributes(
        :id => File.basename(response.headers["Location"]),
      )

      reload
    else
      requires :identity

      service.update_issue(
        "id"          => self.identity,
        "summary"     => self.summary,
        "description" => self.description,
      )
      self.reload
    end
  end
end
