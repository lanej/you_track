class YouTrack::Client::Issues < YouTrack::Client::Collection

  model YouTrack::Client::Issue

  def all(project, filters={})
    project_id = (project.respond_to?(:identity) ? project.identity : project)

    load(service.get_issues(project_id, filters).body)
  end

  def get(identity)
    service.issues.new(
      service.get_issue(identity).body
    )
  rescue Faraday::ResourceNotFound
    nil
  end
end
