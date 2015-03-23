require 'spec_helper'

RSpec.describe YouTrack::Parser::UserParser do
  subject { YouTrack::Parser::UserParser.new(MultiXml.parse(File.read("spec/fixtures/user.xml"))) }

  it "parses user xml" do
    expect(
      subject.parse
    ).to eq(
      {"filterFolder"=>"YTD",
       "lastCreatedProject"=>"ASDFAG",
       "login"=>"root",
       "fullName"=>"root"}
    )
  end
end
