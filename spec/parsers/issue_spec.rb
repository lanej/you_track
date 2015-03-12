require 'spec_helper'

RSpec.describe YouTrack::Parser::IssueParser do
  subject { YouTrack::Parser::IssueParser.new(MultiXml.parse(File.read("spec/fixtures/issue.xml"))) }

  it "should parse issue xml" do
    expect(
      subject.parse
    ).to eq(
      {
        "id"=>"YTD-1",
        "comments"=>[
          {
            "id"=>"43-66363",
            "author"=>"jlane",
            "authorFullName"=>"Josh Lane",
            "issueId"=>"YTD-1",
            "deleted"=>"false",
            "text"=>"created comment",
            "shownForIssueAuthor"=>"false",
            "created"=>"1426195073153",
            "replies"=>nil
          },
          {
            "id"=>"43-66364",
            "author"=>"jlane",
            "authorFullName"=>"Josh Lane",
            "issueId"=>"YTD-1",
            "deleted"=>"true",
            "text"=>"deleted comment",
            "shownForIssueAuthor"=>"false",
            "created"=>"1426195076703",
            "updated"=>"1426195080411",
            "replies"=>nil
          },
          {
            "id"=>"43-66365",
            "author"=>"jlane",
            "authorFullName"=>"Josh Lane",
            "issueId"=>"YTD-1",
            "deleted"=>"false",
            "text"=>"comment with an attachment",
            "shownForIssueAuthor"=>"false",
            "created"=>"1426195142768",
            "replies"=>nil
          }
        ],
        "tag"=>"awsm",
        "projectShortName"=>"YTD",
        "numberInProject"=>"1",
        "summary"=>"test",
        "description"=>"test",
        "created"=>"1426195066605",
        "updated"=>"1426195142776",
        "updaterName"=>"jlane",
        "updaterFullName"=>"Josh Lane",
        "reporterName"=>"jlane",
        "reporterFullName"=>"Josh Lane",
        "commentsCount"=>"2",
        "votes"=>"0",
        "custom_fields" => {
          "Priority"=>"Medium",
          "Type"=>"Bug",
          "State"=>"Open",
          "Subsystem"=>"Unknown subsystem",
          "Scope"=>"Bug",
          "Cookbook Subsystem"=>"Unknown subsystem",
          "Rally State"=>"None Needed",
          "Post Status"=>"Open",
          "Ticket Type"=>"Bug",
        },
        "attachments"=> [
          {
            "id"=>"54-2936",
            "url"=>"https://tickets.engineyard.com/_persistent/1146171_714578067952_220952252_o.jpg?file=54-2936&v=0&c=true",
            "content"=>"1146171_714578067952_220952252_o.jpg"
          },
        ]
      }
    )
  end
end
