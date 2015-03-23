class YouTrack::Client::User < YouTrack::Client::Model
  identity :id, aliases: ["login"]

  attribute :name, alias: "fullName"
  attribute :email
  attribute :last_created_project, aliases: ["lastCreatedProject"]
  attribute :jabber
  attribute :filter_folder, alias: "filterFolder"

  def admin? # just try to make a request to the admin api and see what happens
    return @admin if defined?(@admin) # i love how ||= doesn't work when a variable is false
    @admin = !!service.get_admin_user(self.id).body
  rescue Faraday::ResourceNotFound
    @admin = false
  end

  attr_accessor :password, :username

  def save
    if new_record?
      requires :username, :email

      service.create_user(
        "email"    => self.email,
        "fullName" => self.name,
        "jabber"   => self.jabber,
        "login"    => self.username,
        "password" => self.password,
      )

      merge_attributes(
        :identity => self.username,
      )
    else
      raise NotImplementedError
    end
  end
end
