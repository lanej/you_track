class YouTrack::Client::GetUser < YouTrack::Client::Request
  def real(username)
    service.request(
      :path   => "/user/#{username}",
      :parser => YouTrack::Parser::UserParser,
    )
  end

  def mock(username)
    service.response(
      :body => Cistern::Hash.slice(
        find(:users, username),
        "login", "filterFolder", "lastCreatedProject", "fullName"
      )
    )
  end
end
