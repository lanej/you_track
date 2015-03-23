# https://confluence.jetbrains.com/display/YTD6/Create+New+Issue
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

    project_id = issue["projectShortName"] = issue.delete("project")
    find(:projects, project_id)

    index = service.data[:issues].size + 1
    project_index = service.data[:issues].values.select { |i| i["projectShortName"] == project_id }.size

    identity = "#{project_id}-#{index}"

    issue.merge!(
      "id"               => identity,
      "tag"              => "",
      "numberInProject"  => project_index,
      "created"          => ms_time(Time.now),
      "updated"          => ms_time(Time.now),
      "updaterName"      => service.username,
      "updaterFullName"  => service.username.capitalize,
      "reporterName"     => service.username,
      "reporterFullName" => service.username.capitalize,
      "commentsCount"    => "0",
      "votes"            => "0",
      "attachments"      => [],
      "custom_fields"    => [],
    )

    service.data[:project_custom_fields][project_id].each { |prototype|
      default = if bundle = service.data[:bundles][prototype["defaultBundle"]]
                  bundle["values"][prototype["attachBundlePolicy"].to_i]
                else
                  {}
                end

      if default["resolved"]
        issue["resolved"] = ms_time(Time.now)
      end

      issue["custom_fields"] << [ prototype["name"], default["value"] ]
    }

    service.data[:issues][identity] = issue

    service.response(
      :response_headers => {
        "Location" => service.url_for("/issue/#{identity}"),
      },
      :status => 201,
    )
  end
end
