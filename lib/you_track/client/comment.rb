class YouTrack::Client::Comment < YouTrack::Client::Model
  identity :id

  attribute :author
  attribute :issue_id, aliases: ['issueId']
  attribute :deleted, type: :boolean
  attribute :text
  attribute :shown_for_issue_author, aliases: ['shownForIssueAuthor'], type: :boolean
  attribute :created # Unix time, puke
  attribute :updated # More unix time puke
end
