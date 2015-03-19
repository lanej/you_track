class YouTrack::Client::Project < YouTrack::Client::Model
  identity :id, aliases: ["shortName"]

  attribute :versions,     type: :array
  attribute :name
  attribute :description
  attribute :is_importing, type: :boolean, aliases: ["isImporting"]
  attribute :assignees

  def issues
    service.issues.all(self.id)
  end

  def custom_fields
    service.get_project_custom_fields(self.id).body
  end

  def add_version(version)
    raise YouTrack::NotAnAdminError unless service.current_user.admin?

    unless versions.include?(version)
      service.add_project_fix_version('project' => self.id, 'version' => version)
    end
  end

  def remove_version(version)
    raise YouTrack::NotAnAdminError unless service.current_user.admin?

    if versions.include?(version)
      service.remove_project_fix_version('project' => self.id, 'version' => version)
    end
  end
end
