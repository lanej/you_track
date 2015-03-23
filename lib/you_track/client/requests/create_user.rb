class YouTrack::Client::CreateUser < YouTrack::Client::Request
  include YouTrack::Client::ParameterRequest

  def self.accepted_parameters
    # login     string Login name of a user to be created. Required
    @_accepted_parameters ||= [
      "fullName",  # string  Full name of a new user.
      "email",     # string  New user's e-mail address. Required
      "jabber",    # string  Jabber address for a new user.
      "password",  # string  Password for the new user.
    ]
  end

  def real
    service.request(
      :method => :put,
      :path   => "/admin/user/#{self.identity}",
      :params => self.accepted_parameters,
    )
  end

  def identity
    params.fetch("login")
  end

  def accepted_parameters
    params.fetch("email") # required

    params.slice(*self.class.accepted_parameters)
  end

  def mock
    user = accepted_parameters.merge(
      "filterFolder"       => nil, # wtf does this mean
      "lastCreatedProject" => nil, # not yet
      "login"              => identity,
    )

    service.data[:users][identity] = user

    service.response(status: 201)
  end
end
