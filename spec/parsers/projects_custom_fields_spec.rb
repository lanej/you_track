require 'spec_helper'

RSpec.describe YouTrack::Parser::ProjectCustomFieldsParser do
  subject { described_class.new(MultiXml.parse(File.read("spec/fixtures/project_custom_fields.xml"))) }

  it "parses issue xml" do
    expect(
      subject.parse
    ).to eq(
      [{"name"=>"Priority",
        "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Priority"},
          {"name"=>"Type",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Type"},
          {"name"=>"State",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/State"},
          {"name"=>"Assignee",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Assignee"},
          {"name"=>"Subsystem",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Subsystem"},
          {"name"=>"Fix versions",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Fix%20versions"},
          {"name"=>"Affected versions",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Affected%20versions"},
          {"name"=>"Fixed in build",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Fixed%20in%20build"},
          {"name"=>"Teams",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Teams"},
          {"name"=>"Product",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Product"},
          {"name"=>"Target Distro",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Target%20Distro"},
          {"name"=>"Scope",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Scope"},
          {"name"=>"Cookbook Subsystem",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Cookbook%20Subsystem"},
          {"name"=>"Fixed Distros",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Fixed%20Distros"},
          {"name"=>"Release",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Release"},
          {"name"=>"CC Teams",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/CC%20Teams"},
          {"name"=>"Target Distros",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Target%20Distros"},
          {"name"=>"Rally State",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Rally%20State"},
          {"name"=>"Rally ID",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Rally%20ID"},
          {"name"=>"Post Status",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Post%20Status"},
          {"name"=>"Ticket Type",
           "url"=>
        "https://tickets.engineyard.com/rest/admin/project/YTD/customfield/Ticket%20Type"}]
    )
  end
end
