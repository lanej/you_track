class YouTrack::Client::Issues < YouTrack::Client::Collection

  attribute :project_id

  model YouTrack::Client::Issue

  def all(project, filters={})
    project_id = (project.respond_to?(:identity) ? project.identity : project)

    response = service.get_issues(project_id, filters)
    merge_attributes(project_id: project_id)
    load(response.body)
  end

  def get(identity)
    service.issues.new(
      service.get_issue(identity).body
    )
  rescue Faraday::ResourceNotFound
    nil
  end
end
