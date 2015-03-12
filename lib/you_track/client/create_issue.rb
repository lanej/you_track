class YouTrack::Client::CreateIssue < YouTrack::Client::Request
  def real(params)
    service.request(
      :path   => "/issue",
      :method => :put,
      :params => params,
      :parser => YouTrack::Parser::IssueParser,
    )
  end

  def mock(_params)
    params = Cistern::Hash.stringify_keys(_params)

    issue = Cistern::Hash.slice(params, "project", "description", "summary")

    project = issue["projectShortName"] = issue.delete("project")

    identity = service.data[:issues].size + 1


    issue.merge!(
      "id"               => "#{project}-#{identity}",
      "tag"              => "",
      "numberInProject"  => identity,
      "created"          => Time.now.to_i * 1000,
      "updated"          => Time.now.to_i * 1000,
      "updaterName"      => service.username,
      "updaterFullName"  => service.username.capitalize,
      "reporterName"     => service.username,
      "reporterFullName" => service.username.capitalize,
      "commentsCount"    => "0",
      "votes"            => "0",
      "custom_fields"    => [], # @fixme need these
      "attachments"      => [],
    )

    service.response(
      :body   => issue,
      :status => 201,
    )
  end
end
