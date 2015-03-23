class YouTrack::Client::ApplyIssueCommand < YouTrack::Client::Request
  include YouTrack::Client::ParameterRequest

  def identity
    params.fetch("id")
  end

  def real
    service.request(
      :path   => "/issue/#{identity}/execute",
      :query  => params,
      :method => :post,
    )
  end

  def mock
    issue      = find(:issues, identity)
    comment_id = "#{Cistern::Mock.random_numbers(2)}-#{Cistern::Mock.random_numbers(5)}"

    if comment = params["comment"]
      service.data[:comments][comment_id] = {
        "id"             => comment_id,
        "author"         => service.username,
        "deleted"        => false,
        "text"           => comment,
        "shownForIssuer" => false,
        "created"        => ms_time,
        "issueId"        => identity,
      }
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
