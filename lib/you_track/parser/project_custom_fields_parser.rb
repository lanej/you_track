class YouTrack::Parser::ProjectCustomFieldsParser < YouTrack::Parser::Base
  def parse
    return [] unless raw["projectCustomFieldRefs"]
    raw["projectCustomFieldRefs"]["projectCustomField"]
  end
end
