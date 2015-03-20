class YouTrack::Client::Projects < YouTrack::Client::Collection
  model YouTrack::Client::Project

  def all
    load(service.get_projects.body)
  end

  def get(identity)
    find { |p| p.identity == identity }
  end
end
