class YouTrack::Parser::IssuesParser < YouTrack::Parser::IssueParser
  def parse
    return [] if raw["issues"].nil?      # i hate xml
    results = raw["issues"]["issue"].dup # i really hate xml

    results.each do |result|
      fields = result.delete("field")
      standard_fields = fields.select { |k| k["xsi:type"] == "SingleField" }
      fields = fields - standard_fields
      attachments = fields.select { |k| k["xsi:type"] == "AttachmentField" }
      custom_fields = fields - attachments

      result.merge!(parse_fields(standard_fields))
      result["custom_fields"] = parse_fields(custom_fields)
      result["attachments"]   = parse_attachments(attachments)
      result["comments"]      = results.delete("comment")
    end

    results
  end
end
