module ResourceHelper
  def create_project(client, name: Faker::Name.title, prefix: SecureRandom.hex(4).upcase)
    client.projects.create(
      :prefix => prefix,
      :name   => name,
    )
  end

  def create_issue(client: client, issue: {}, project: nil)
    issue[:project] ||= ENV["YOUTRACK_PROJECT"] || create_project(client)
    issue[:summary] ||= Faker::Lorem.sentence(1)
    issue[:description] ||= Faker::Lorem.paragraph(2)

    client.issues.create(issue)
  end

  def create_user(client, user: {})
    name =
      user[:name]   ||= Faker::Name.name
    user[:username] ||= Faker::Internet.user_name(name)
    user[:email]    ||= Faker::Internet.safe_email(name)

    client.users.create(user)
  end
end

RSpec.configure do |config|
  config.include(ResourceHelper)
end
