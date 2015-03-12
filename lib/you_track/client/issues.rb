class YouTrack::Client::Issues < YouTrack::Client::Collection

  model YouTrack::Client::Issue

  def get(identity)
    service.issues.new(
      service.get_issue(identity).body
    )
  end
end
