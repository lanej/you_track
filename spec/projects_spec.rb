require 'spec_helper'

describe "as a customer" do
  let!(:client) { create_client }
  before        {
    unless client.current_user.admin?
      skip "User must be an admin"
    end
  }

  it "should create a project" do
    client.projects.create(
      :prefix => SecureRandom.hex(4).upcase,
      :name   => Faker::Name.title,
    )
  end

  context "with a project" do
    let!(:project) { create_project(client) }

    it "lists projects" do
      expect(client.projects.all).to include(project)
    end

    it "gets a project" do
      expect(client.projects.get(project.id)).to eq(project)
    end

    context "with an issue" do
      let!(:issue) {
        client.issues.create(project: project, summary: Faker::Lorem.sentence(1), description: Faker::Lorem.paragraph(2))
      }

      it "lists issues on the project" do
        expect(project.issues).to include(issue)
      end
    end

    context "with an admin user" do

      it "has custom fields" do
        expect(project.custom_fields.map { |cf| cf["name"] }).to include("Fix versions")
      end

      it "adds a version to the project" do
        expect {
          project.add_version(SecureRandom.uuid)
        }.to change { project.reload.versions.count }
      end

      it "removes a version from a project" do
        project.add_version(SecureRandom.uuid) if project.versions.empty?
        version = project.reload.versions.last

        expect {
          project.remove_version(version)
        }.to change { project.reload.versions.count }
      end

      it "does not add a version when the user is not an admin" do
        client.current_user.instance_variable_set(:@admin, false)

        expect {
          project.add_version(SecureRandom.uuid)
        }.to raise_error(YouTrack::NotAnAdminError)

        client.current_user.instance_variable_set(:@admin, true)
      end
    end
  end
end
