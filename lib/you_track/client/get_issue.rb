class YouTrack::Client::GetIssue < YouTrack::Client::Request
  def real(issue_id)
    service.request(
      :path   => "/issue/#{issue_id}",
      :parser => YouTrack::Parser::IssueParser,
    )
  end

  def mock(issue_id)
    service.response(
      :body => find(:issues, issue_id)
    )
  end
end
