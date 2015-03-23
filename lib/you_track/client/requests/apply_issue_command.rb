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

    if command = params["command"]
      words = command.scan(/[^\s]+/) # ["State", "In", "Progress", "Assignee", "jlane"]
      acceptable_commands = find(:project_custom_fields, issue["projectShortName"]).map { |cf| cf["name"] }

      command_map = Hash.new { |h,k| h[k] = [] }

      current_command = words.shift
      words.each do |word|
        unless acceptable_commands.include?(word)
          command_map[current_command] << word
        else
          # @todo validate command on closer
          current_command = word
        end
      end

      commands = command_map.inject({}) { |r,(k,v)| r.merge(k => v.join(" ")) }

      commands.each do |field, value|
        prototype = service.data[:custom_fields].fetch(field)

        bundle_value = if bundle = service.data[:bundles][prototype["defaultBundle"]]
                         bundle["values"].find { |v| v["value"] == value }
                       else # @fixme explode
                         {}
                       end

        if bundle_value["resolved"] == "true"
          issue["resolved"] = ms_time(Time.now)
        end

        issue["custom_fields"].find { |name, _| name == field }[1] = value
      end
    end

    service.response
  end
end
