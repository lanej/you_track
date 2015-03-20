class YouTrack::Client::AddProjectFixVersion < YouTrack::Client::Request
  def real(params={})
    project = params.delete("project")
    version = params.delete("version")

    service.request(
      :path   => "/admin/project/#{project}/version/#{version}",
      :method => :put,
    )
  end

  def mock(params={})
    project = find(:projects, params.delete("project"))

    project["versions"] << params.delete("version")

    service.response
  end
end
