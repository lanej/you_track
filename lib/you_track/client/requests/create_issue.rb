class YouTrack::Client::CreateIssue < YouTrack::Client::Request
  def real(params)
    service.request(
      :path   => "/issue",
      :method => :put,
      :params => params,
    )
  end

  def mock(_params)
    params = Cistern::Hash.stringify_keys(_params)

    issue = Cistern::Hash.slice(params, "project", "description", "summary")

    project = issue["projectShortName"] = issue.delete("project")

    index = service.data[:issues].size + 1
    project_index = service.data[:issues].values.select { |i| i["projectShortName"] == project }.size

    identity = "#{project}-#{index}"

    issue.merge!(
      "id"               => identity,
      "tag"              => "",
      "numberInProject"  => project_index,
      "created"          => Time.now.to_i * 1000,
      "updated"          => Time.now.to_i * 1000,
      "updaterName"      => service.username,
      "updaterFullName"  => service.username.capitalize,
      "reporterName"     => service.username,
      "reporterFullName" => service.username.capitalize,
      "commentsCount"    => "0",
      "votes"            => "0",
      "custom_fields"    => [
        ["State", "Open"],
      ], # @fixme need these
      "attachments"      => [],
    )

    service.data[:issues][identity] = issue

    service.response(
      :status => 201,
    )
  end
end
