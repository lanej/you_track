class YouTrack::Client::GetCurrentUser < YouTrack::Client::Request
  def real
    service.request(
      :path   => "/user/current",
      :parser => YouTrack::Parser::UserParser,
    )
  end

  def mock
    service.response(
      :body => service.set_current_user,
    )
  end
end
