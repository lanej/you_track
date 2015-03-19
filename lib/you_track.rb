require "you_track/version"

require "logger"
require "uri"

require "cistern"
require "faraday"
require "faraday-cookie_jar"
require "faraday_middleware"
require "multi_xml"

module YouTrack
  def self.defaults
    @defaults ||= begin
                    YAML.load_file(File.expand_path("~/.youtrack"))
                  rescue ArgumentError, Errno::ENOENT
                    # handle missing home directories or missing file
                    {}
                  end
  end

  class NotAnAdminError < StandardError; end
end


require_relative "you_track/client"

require_relative "you_track/parser"
