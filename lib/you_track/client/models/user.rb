class YouTrack::Client::User < YouTrack::Client::Model
  identity :id, aliases: ["email"]

  attribute :name, alias: "fullName"
  attribute :last_created_project, aliases: ["lastCreatedProject"]

  def admin? # just try to make a request to the admin api and see what happens
    return @admin if defined?(@admin) # i love how ||= doesn't work when a variable is false
    @admin = !!service.get_admin_user(self.id).body
  rescue Faraday::ResourceNotFound
    @admin = false
  end
end
