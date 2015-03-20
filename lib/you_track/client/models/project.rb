class YouTrack::Client::Project < YouTrack::Client::Model
  identity :id, aliases: ["shortName"]

  attribute :versions,     type: :array, default: []
  attribute :name
  attribute :description
  attribute :is_importing, type: :boolean, aliases: ["isImporting"]
  attribute :assignees

  attr_accessor :starting_number, :lead, :prefix

  def issues
    service.issues.all(self.identity)
  end

  def custom_fields
    service.get_project_custom_fields(self.id).body
  end

  def save
    if new_record?
      requires :name, :prefix

      starting_number = self.starting_number || 1
      lead            = self.lead            || service.current_user

      lead_id = (lead.is_a?(YouTrack::Client::User) ? lead.identity : lead)

      service.create_project(
        "projectId"        => self.prefix,
        "projectName"      => self.name,
        "startingNumber"   => starting_number,
        "projectLeadLogin" => lead_id,
        "description"      => self.description,
      )

      merge_attributes(
        :identity => self.prefix,
      )
    else
      raise NotImplementedError
    end
  end

  def add_version(version)
    require_admin!

    unless versions.include?(version)
      service.add_project_fix_version('project' => self.id, 'version' => version)
      self.versions << version
    end

    self.versions
  end

  def reload
    merge_attributes(collection.reload.get(self.identity).attributes)
  end

  def remove_version(version)
    require_admin!

    if versions.include?(version)
      service.remove_project_fix_version('project' => self.id, 'version' => version)
      self.versions.delete(version)
    end

    self.versions
  end
end
