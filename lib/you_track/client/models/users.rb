class YouTrack::Client::Users < YouTrack::Client::Collection
  model YouTrack::Client::User

  def current
    service.users.new(service.get_current_user.body)
  end
end
