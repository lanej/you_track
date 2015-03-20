require 'spec_helper'

describe "as a customer" do
  let!(:client)  { create_client }

  it "gets information about the current user" do
    expect(client.users.current.identity).to match(client.username)
  end
end
