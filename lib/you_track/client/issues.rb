class YouTrack::Client::Issues < YouTrack::Client::Collection

  model YouTrack::Client::Issue

  def all(project, filters={})
    service.issues.load(service.get_issues(project, filters).body)
  end

  def get(identity)
    service.issues.new(
      service.get_issue(identity).body
    )
  rescue Faraday::ResourceNotFound
    nil
  end

  def delete(identity)
    service.request(
      :path   => "/issue/#{identity}",
      :method => :delete,
    )
  end
end
