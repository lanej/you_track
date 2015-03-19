require 'spec_helper'

describe "as a customer" do
  let!(:client)  { create_client }
  let!(:project) { ENV["YOUTRACK_PROJECT"] || "YTD" }

  it "lists projects" do
    expect(client.projects.all).not_to be_empty
  end

  it "gets a project" do
    expect(client.projects.get(project).id).to eq(project)
  end

  context "with an issue" do
    before(:each) do
      @issue = client.issues.get("#{project}-1") || client.issues.create(project: project, summary: Faker::Lorem.sentence(1), description: Faker::Lorem.paragraph(2))
    end

    it "lists issues on the project" do
      expect(client.projects.get(project).issues).to include(@issue)
    end
  end

  context "with an admin user" do
    before(:each) do
      pending "User must be an admin" unless client.current_user.admin?
      @project = client.projects.get(project)
    end

    it "has custom fields" do
      expect(@project.custom_fields.map { |cf| cf["name"] }).to include("Fix versions")
    end

    it "adds a version to the project" do
      expect {
        @project.add_version(SecureRandom.uuid)
      }.to change { @project.reload.versions.count }
    end

    it "removes a version from a project" do
      @project.add_version(SecureRandom.uuid) if @project.versions.empty?
      version = @project.reload.versions.last
      expect {
        @project.remove_version(version)
      }.to change { @project.reload.versions.count }
    end

    it "does not add a version when the user is not an admin" do
      client.current_user.instance_variable_set(:@admin, false)
      expect {
        @project.add_version(SecureRandom.uuid)
      }.to raise_error(YouTrack::NotAnAdminError)
      client.current_user.instance_variable_set(:@admin, true)
    end
  end
end
