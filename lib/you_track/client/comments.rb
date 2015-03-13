class YouTrack::Client::Comments < YouTrack::Client::Collection
  model YouTrack::Client::Comment

  def all(issue_id)
    service.comments.load(service.get_issue_comments(issue_id).body)
  end
end
