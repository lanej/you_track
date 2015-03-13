module ResourceHelper
  def create_issue(client: client, issue: {}, project: nil)
    issue[:project] ||= ENV["YOUTRACK_PROJECT"] || "YTD"
    issue[:summary] ||= Faker::Lorem.sentence(1)
    issue[:description] ||= Faker::Lorem.paragraph(2)

    client.issues.create(issue)
  end
end

RSpec.configure do |config|
  config.include(ResourceHelper)
end
