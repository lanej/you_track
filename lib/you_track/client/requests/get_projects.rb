class YouTrack::Client::GetProjects < YouTrack::Client::Request

  def self.attributes
    @_attributes ||= %w[name shortName isImporting subsystems assignees versions]
  end

  def real
    service.request(
      :path   => "/project/all",
      :parser => YouTrack::Parser::ProjectsParser,
      :query  => {"verbose" => true},
    )
  end

  def mock
    service.response(
      :body => service.data[:projects].values.map { |p| Cistern::Hash.slice(p, *self.class.attributes) }
    )
  end
end
