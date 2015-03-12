class YouTrack::Client::Login < YouTrack::Client::Request
  def real(username, password)
    service.request(
      :method => :post,
      :params => {login: username, password: password},
      :path   => "/user/login",
    )
  end
end
