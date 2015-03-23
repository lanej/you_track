# https://confluence.jetbrains.com/display/YTD6/Update+an+Issue
class YouTrack::Client::UpdateIssue < YouTrack::Client::Request
  include YouTrack::Client::ParameterRequest

  def self.accepted_attributes
    # issueID # string  ID of an issue that should be updated.
    @_accepted_attributes ||= [
      "summary",     # string  New summary for the specified issue.
      "description", # string  Updated description for the specified issue.
    ]
  end

  def identity
    params.fetch("id")
  end

  def accepted_attributes
    Cistern::Hash.slice(params, *self.class.accepted_attributes)
  end

  def real
    service.request(
      :path   => "/issue/#{params.fetch("id")}",
      :method => :post,
      :query  => accepted_attributes,
    )
  end

  def mock
    find(:issues, identity).merge!(accepted_attributes)

    service.response
  end
end
