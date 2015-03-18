class YouTrack::Parser::UserParser < YouTrack::Parser::Base
  def parse
    raw["user"]
  end
end
