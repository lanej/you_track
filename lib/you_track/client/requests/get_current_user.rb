class YouTrack::Client::GetCurrentUser < YouTrack::Client::Request
  def real
    service.request(
      :path   => "/user/current",
      :parser => YouTrack::Parser::UserParser,
    )
  end

  def mock
    service.response(
      :body => find(:users, service.username)
    )
  end
end
