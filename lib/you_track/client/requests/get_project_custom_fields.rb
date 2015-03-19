class YouTrack::Client::GetProjectCustomFields < YouTrack::Client::Request
  def real(id)
    service.request(
      :path   => "/admin/project/#{id}/customfield",
      :parser => YouTrack::Parser::ProjectCustomFieldsParser,
    )
  end

  def mock(id)
    service.response(body: find(:custom_fields, id))
  end
end
