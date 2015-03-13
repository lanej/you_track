class YouTrack::Client::GetIssueComments < YouTrack::Client::Request
  def real(issue_id)
    service.request(
      :path => "/issue/#{issue_id}/comment",
      :parser => YouTrack::Parser::CommentsParser,
    )
  end

  def mock(issue_id)
    service.response(
      :body => service.data[:comments].values.select { |c| c['issueId'] == issue_id }
    )
  end
end
