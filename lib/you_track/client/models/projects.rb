class YouTrack::Client::Projects < YouTrack::Client::Collection
  model YouTrack::Client::Project

  def all
    service.projects.load(service.get_projects.body)
  end

  def get(identity)
    all.detect { |p| p.id == identity }
  end
end
