module ClientHelper
  def create_client(options={})
    options.merge!(logger: Logger.new(STDOUT)) if ENV['VERBOSE']
    options = {
      :username => ENV["YOUTRACK_USERNAME"] || "lanej",
      :password => ENV["YOUTRACK_PASSWORD"] || "password",
      :url      => ENV["YOUTRACK_URL"]      || "https://tickets.example.org",
    }.merge(options)

    YouTrack::Client.new(options)
  end
end

RSpec.configure do |config|
  config.include(ClientHelper)
end
