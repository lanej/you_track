require 'spec_helper'

RSpec.describe YouTrack::Parser::ProjectsParser do
  subject { described_class.new(MultiXml.parse(File.read("spec/fixtures/project.xml"))) }

  it "parses issue xml" do
    expect(
      subject.parse
    ).to eq(
      [{"name"=>"YTD",
        "shortName"=>"YTD",
        "isImporting"=>"false",
        "subsystems"=>{"sub"=>{"value"=>"No subsystem"}},
        "assignees"=>{},
        "versions"=>["v1", "v2", "68559484-86d8-452d-9534-246a36745922"]},
      {"name"=>"asfd",
       "shortName"=>"ASDFAG",
       "isImporting"=>"false",
       "subsystems"=>{"sub"=>{"value"=>"No subsystem"}},
       "assignees"=>{"root"=>"root", "guest"=>"guest", "jlane"=>"Joshua Lane"},
       "versions"=>[]}]
    )
  end
end
