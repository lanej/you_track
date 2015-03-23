require 'spec_helper'

RSpec.describe YouTrack::Parser::StateBundleParser do
  subject { described_class.new(MultiXml.parse(File.read("spec/fixtures/state_bundle.xml"))) }

  it "parses state_bundle xml" do
    expect(
      subject.parse
    ).to eq(
      {"name"=>"States",
       "states"=>
       [{"resolved"=>"false", "value"=>"Submitted"},
        {"resolved"=>"false", "value"=>"Open"},
        {"resolved"=>"false", "value"=>"In Progress"},
        {"resolved"=>"false", "value"=>"To be discussed"},
        {"resolved"=>"false", "value"=>"Reopened"},
        {"resolved"=>"true", "value"=>"Can't Reproduce"},
        {"resolved"=>"true", "value"=>"Duplicate"},
        {"resolved"=>"true", "value"=>"Fixed"},
        {"resolved"=>"true", "value"=>"Won't fix"},
        {"resolved"=>"true", "value"=>"Incomplete"},
        {"resolved"=>"true", "value"=>"Obsolete"},
        {"resolved"=>"true", "value"=>"Verified"},
        {"resolved"=>"false", "value"=>"New"}]}
    )
  end
end
