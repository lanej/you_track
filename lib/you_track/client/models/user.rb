class YouTrack::Client::User < YouTrack::Client::Model
  identity :id, aliases: ["fullName", "email"]

  attribute :last_created_project, aliases: ["lastCreatedProject"]
  attribute :email,                aliases: ["email"]

  def admin? # just try to make a request to the admin api and see what happens
    return @admin if defined?(@admin) # i love how ||= doesn't work when a variable is false
    @admin = !!service.get_admin_user(self.id).body
  rescue Faraday::ResourceNotFound
    @admin = false
  end
end
