class YouTrack::Parser::ProjectsParser < YouTrack::Parser::Base
  def parse_assignees(login, full_name)
    return {} unless login && full_name
    login["sub"]     = [login["sub"]] if login["sub"].is_a?(Hash)
    full_name["sub"] = [full_name["sub"]] if full_name["sub"].is_a?(Hash)
    login["sub"].each_with_index.inject({}) do |hash, (user,i)|
      hash[user["value"]] = full_name["sub"][i]["value"]
      hash
    end
  end

  def parse_versions(versions)
    return [] unless versions
    Array(versions.gsub(/(^\[|\]$)/, '').split(', '))
  end

  def parse
    return [] if raw["projects"].nil?
    results = raw["projects"]["project"].dup
    results = [results] if results.is_a?(Hash)
    results.each do |result|
      login     = result.delete("assigneesLogin")
      full_name = result.delete("assigneesFullName")
      versions  = result.delete("versions")

      result["assignees"] = parse_assignees(login, full_name)
      result["versions"]  = parse_versions(versions)
    end

    results
  end
end
