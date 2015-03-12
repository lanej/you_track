$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'you_track'

ENV['MOCK_YOUTRACK'] ||= 'true'

Bundler.require(:default, :test)

Dir[File.expand_path("../{support,shared}/**/*.rb", __FILE__)].each {|f| require f}

if ENV["MOCK_YOUTRACK"] == 'true'
  YouTrack::Client.mock!
end

Cistern.formatter = Cistern::Formatter::AwesomePrint

RSpec.configure do |config|
  if YouTrack::Client.mocking?
    config.before(:each) { YouTrack::Client.reset! }
  else
    config.filter_run_excluding(mock_only: true)
  end
  config.filter_run(:focus => true)
  config.run_all_when_everything_filtered = true

  config.order = "random"
end
