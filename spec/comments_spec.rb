require 'spec_helper'

describe "as a customer" do
  let!(:client)  { create_client }
  let!(:project) { create_project(client) }

  context "with an issue" do
    let!(:issue) { client.issues.create(project: project, summary: Faker::Lorem.sentence(1), description: Faker::Lorem.paragraph(2)) }

    it "adds a comment to an issue" do
      new_comment = Faker::Lorem.sentence(1)
      comment     = issue.comment(new_comment)
      expect(comment.text).to eq(new_comment)
    end

    context "with a comment" do
      let!(:comment) { issue.comment(Faker::Lorem.sentence(1)) }

      it "lists comments on an issue" do
        expect(issue.comments).to include(comment)
      end
    end
  end
end
