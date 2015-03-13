class YouTrack::Parser::IssueParser < YouTrack::Parser::Base
  def parse_attachments(attachments)
    attachments.inject([]) { |r, a|
      value = a["value"]
      r << {"id" => value["id"], "url" => value["url"], "content" => value["__content__"]}
    }
  end

  def parse
    results = raw["issue"].dup

    fields = results.delete("field")
    standard_fields = fields.select { |k| k["xsi:type"] == "SingleField" }
    fields = fields - standard_fields
    attachments = fields.select { |k| k["xsi:type"] == "AttachmentField" }
    custom_fields = fields - attachments

    results.merge!(parse_fields(standard_fields))
    results["custom_fields"] = parse_fields(custom_fields)
    results["attachments"] = parse_attachments(attachments)
    results["comments"] = results.delete("comment")

    results
  end
end
