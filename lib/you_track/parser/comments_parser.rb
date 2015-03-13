class YouTrack::Parser::CommentsParser < YouTrack::Parser::Base
  def parse
    return [] if raw["comments"].nil?
    raw["comments"]["comment"]
  end
end
