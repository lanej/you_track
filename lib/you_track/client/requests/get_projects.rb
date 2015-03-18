class YouTrack::Client::GetProjects < YouTrack::Client::Request
  def real
    service.request(
      :path   => "/project/all",
      :parser => YouTrack::Parser::ProjectsParser,
      :query  => {"verbose" => true},
    )
  end

  def mock
    service.response(
      :body => service.data[:projects].values
    )
  end
end
