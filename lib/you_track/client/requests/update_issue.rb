class YouTrack::Client::UpdateIssue < YouTrack::Client::Request
  def real(params={})
    id = params.delete("id")
    service.request(
      :path   => "/issue/#{id}",
      :method => :post,
      :query  => params,
    )
  end

  def mock(params={})
    id    = params.delete("id")
    issue = find(:issues, id)

    issue.merge!(params)
    service.data[:issues][id] = issue

    service.response
  end
end
