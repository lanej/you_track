class YouTrack::Client::Issues < YouTrack::Client::Collection

  model YouTrack::Client::Issue

  def all(project, filters={})
    load(service.get_issues(project, filters).body)
  end

  def get(identity)
    service.issues.new(
      service.get_issue(identity).body
    )
  rescue Faraday::ResourceNotFound
    nil
  end
end
