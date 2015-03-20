# https://confluence.jetbrains.com/display/YTD6/PUT+Project
class YouTrack::Client::CreateProject < YouTrack::Client::Request
  def self.accepted_attributes
    # "projectId",        # string  required   Unique identifier of a project to be created. This short name will be used as prefix in issue IDs for this project.
    @_accepted_attributes ||= [
      "projectName",      # string  required   Full name of a new project. Must be unique.
      "startingNumber",   # integer required   Number to assign to the next manually created issue.
      "projectLeadLogin", # string  required   Login name of a user to be assigned as a project leader.
      "description",      # string  Optional   description of the new project.
    ]
  end

  def real(params)
    service.request(
      :path   => "/admin/project/#{params.fetch("projectId")}",
      :method => :put,
      :params => Cistern::Hash.slice(params, *self.class.accepted_attributes),
    )
  end

  def mock(params)
    identity = params.fetch("projectId")

    service.data[:projects][identity] = {
      "isImporting"    => "false",
      "lead"           => params.fetch("projectLeadLogin"), # @todo check user login
      "shortName"      => identity,
      "name"           => params.fetch("projectName"),
      "startingNumber" => params.fetch("startingNumber"),
      "sub"            => { "value" => "No subsystem" },
      "versions"       => [],
    }.merge(Cistern::Hash.slice(params, "description"))

    # @hack
    service.data[:custom_fields][identity] = [
      {"name" => "Fix versions", "url" => service.url_for("/admin/project/#{identity}/customfield/Fix versions")}
    ]

    service.response(status: 201)
  end
end
