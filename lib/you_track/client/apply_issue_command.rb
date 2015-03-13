class YouTrack::Client::ApplyIssueCommand < YouTrack::Client::Request
  def real(params={})
    id = params.delete("id")

    service.request(
      :path   => "/issue/#{id}/execute",
      :query  => params,
      :method => :post,
    )
  end

  def mock(params={})
    id         = params.delete("id")
    issue      = find(:issues, id)
    comment_id = "#{Cistern::Mock.random_numbers(2)}-#{Cistern::Mock.random_numbers(5)}"

    if params["comment"]
      comment = {
        "id"             => comment_id,
        "author"         => service.username,
        "deleted"        => false,
        "text"           => params["comment"],
        "shownForIssuer" => false,
        "created"        => Time.now.to_i * 1000,
        "issueId"        => id,
      }
      service.data[:comments][comment_id] = comment
    end

    if params["command"]
      commands = params["command"].split.each_slice(2).map { |a| [a[0], a[1]] }
      commands.each do |command|
        issue["custom_fields"].detect { |f| f[0] == command[0] }[1] = command[1]
      end
    end

    service.response
  end
end
