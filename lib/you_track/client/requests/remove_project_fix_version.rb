class YouTrack::Client::RemoveProjectFixVersion < YouTrack::Client::Request
  def real(params={})
    project = params.delete("project")
    version = params.delete("version")

    service.request(
      :path   => "/admin/project/#{project}/version/#{version}",
      :method => :delete,
    )
  end

  def mock(params={})
    project = find(:projects, params.delete("project"))
    version = params.delete("version")

    project["versions"].delete(version)

    service.response
  end
end
