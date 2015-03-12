require 'spec_helper'

describe "as a customer" do
  let!(:client) { create_client }

  it "should create an issue" do
    project     = ENV["YOUTRACK_PROJECT"] || "YTD"
    summary     = Faker::Lorem.sentence(1)
    description = Faker::Lorem.paragraph(2)

    issue = client.issues.create(
      :project     => project,
      :summary     => summary,
      :description => description,
    )

    expect(issue.project).to     eq(project)
    expect(issue.id).to          match(project)
    expect(issue.summary).to     eq(summary)
    expect(issue.description).to eq(description)

  end
end
