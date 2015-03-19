class YouTrack::Parser::CommentsParser < YouTrack::Parser::Base
  def parse
    return [] if raw["comments"].nil?
    return [raw["comments"]["comment"]] if raw["comments"]["comment"].is_a?(Hash)
    raw["comments"]["comment"]
  end
end
