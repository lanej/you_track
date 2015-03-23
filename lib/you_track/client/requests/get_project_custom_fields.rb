# https://confluence.jetbrains.com/display/YTD6/GET+Project+Custom+Fields
class YouTrack::Client::GetProjectCustomFields < YouTrack::Client::Request
  def real(id)
    service.request(
      :path   => "/admin/project/#{id}/customfield",
      :parser => YouTrack::Parser::ProjectCustomFieldsParser,
    )
  end

  def mock(id)
    prototypes = find(:project_custom_fields, id)

    body = prototypes.inject([]) { |r,p|
      name = p.fetch("name")

      r << {
        "name" => name,
        "url"  => service.url_for("/admin/project/#{id}/#{name}"),
      }
    }

    service.response(body: body)
  end
end
