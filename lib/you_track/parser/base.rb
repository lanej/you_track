class YouTrack::Parser::Base
  attr_reader :raw

  def initialize(raw)
    @raw = raw
  end

  def parse_fields(fields)
    fields.inject({}) { |r, f| r.merge(f["name"] => f["value"]) }
  end
end
