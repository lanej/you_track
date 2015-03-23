require 'spec_helper'

describe "as a customer" do
  let!(:client) { create_client }

  it "should create a user" do
    name = Faker::Name.name

    username = Faker::Internet.user_name(name)
    email    = Faker::Internet.email(name)

    user = client.users.create(username: username, email: email, name: name)

    expect(user.identity).to eq(user.username)

    fetched_user = client.users.get(user.identity)

    expect(fetched_user.name).to     eq(name)
    expect(fetched_user.identity).to eq(username)
  end

  it "gets information about the current user" do
    expect(client.users.current.identity).to match(client.username)
  end
end
