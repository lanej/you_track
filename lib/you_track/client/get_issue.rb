class YouTrack::Client::GetIssue < YouTrack::Client::Request
  def real(issue_id)
    service.request(
      :path   => "/issue/#{issue_id}",
      :parser => YouTrack::Parser::IssueParser,
    )
  end

  #<?xml version="1.0" encoding="UTF-8" standalone="yes"?><error>Issue not found.</error>
end
