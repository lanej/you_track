class YouTrack::Client::GetAdminUser < YouTrack::Client::Request
  def real(id)
    service.request(
      :path   => "/admin/user/#{id}",
      :parser => YouTrack::Parser::UserParser,
    )
  end

  def mock(id)
    service.response(
      :body => find(:users, id)
    )
  end
end
