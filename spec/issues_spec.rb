require 'spec_helper'

describe "as a customer" do
  let!(:client)  { create_client }
  let!(:project) { ENV["YOUTRACK_PROJECT"] || "YTD" }

  it "creates an issue" do
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

  context "with an issue" do
    before(:each) do
      @issue = client.issues.get("#{project}-1") || client.issues.create(project: project, summary: Faker::Lorem.sentence(1), description: Faker::Lorem.paragraph(2))
    end

    let!(:issue) { @issue }

    it "should get an issue" do
      expect(client.issues.get(issue.identity)).to eq(issue)
    end

    it "lists issues" do
      expect(client.issues.all(project)).to include(@issue)
    end

    it "should list no issues" do
      expect(client.issues.all(project, {"after" => 100})).to be_empty
    end
  end
end
