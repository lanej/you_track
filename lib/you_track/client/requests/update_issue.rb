# https://confluence.jetbrains.com/display/YTD6/Update+an+Issue
class YouTrack::Client::UpdateIssue < YouTrack::Client::Request
  def real(params={})
    service.request(
      :path   => "/issue/#{params.fetch("id")}",
      :method => :post,
      :query  => params,
    )
  end

  def mock(params={})
    id    = params.fetch("id")
    issue = find(:issues, id)

    issue.merge!(params)
    service.data[:issues][id] = issue

    service.response
  end
end
