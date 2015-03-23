class YouTrack::Client::Mock
  attr_reader :url, :username

  def self.data
    @data ||= Hash.new { |h,k|
      h[k] = {
        :issues   => {},
        :comments => {},
        :users    => {},
        :projects => {},
        :custom_fields => {
          "Type"              => {
            "name"               => "Type",
            "isPrivate"          => false,
            "visibleByDefault"   => true,
            "autoAttached"       => true,
            "type"               => "enum[1]",
            "attachBundlePolicy" => 0,
            "defaultBundle"      => "Types",
          },
          "Priority"          => {
            "name"               => "Priority",
            "isPrivate"          => false,
            "visibleByDefault"   => true,
            "autoAttached"       => true,
            "type"               => "enum[1]",
            "attachBundlePolicy" => 0,
            "defaultBundle"      => "Priorties",
          },
          "State"             => {
            "name"               => "State",
            "isPrivate"          => false,
            "visibleByDefault"   => true,
            "autoAttached"       => true,
            "type"               => "state[1]",
            "attachBundlePolicy" => 0,
            "defaultBundle"      => "States",
          },
          "Subsystem"         => {
            "name"               => "Subsystem",
            "isPrivate"          => false,
            "visibleByDefault"   => true,
            "autoAttached"       => true,
            "type"               => "ownedField[1]",
            "attachBundlePolicy" => 1,
            "defaultBundle"      => "Subsystems",
          },
          "Fixed in build"    => {
            "name"               => "Fixed in build",
            "isPrivate"          => false,
            "visibleByDefault"   => true,
            "autoAttached"       => true,
            "type"               => "build[1]",
            "attachBundlePolicy" => 1,
            "defaultBundle"      => "Builds",
          },
          "Assignee"          => {
            "name"             => "Assignee",
            "isPrivate"        => false,
            "visibleByDefault" => true,
            "autoAttached"     => true,
            "type"             => "user[1]",
          },
          "Affected versions" => {
            "name"               => "Affected versions",
            "isPrivate"          => false,
            "visibleByDefault"   => true,
            "autoAttached"       => true,
            "type"               => "version[*]",
            "attachBundlePolicy" => 1,
            "defaultBundle"      => "Versions",
          },
          "Fix versions"      => {
            "name"               => "Fix Versions",
            "isPrivate"          => false,
            "visibleByDefault"   => true,
            "autoAttached"       => true,
            "type"               => "version[*]",
            "attachBundlePolicy" => 1,
            "defaultBundle"      => "Versions",
          },
          "Due Date"          => {
            "name"             => "Due Date",
            "isPrivate"        => false,
            "visibleByDefault" => true,
            "autoAttached"     => true,
            "type"             => "date",
          },
        }
      }
    }
  end

  def self.reset!
    data.clear
  end

  def data
    self.class.data[@url]
  end

  attr_accessor :last_request

  def url_for(path, options={})
    URI.parse(
      File.join(self.url.to_s, "/rest", URI.escape(path.to_s))
    ).tap do |uri|
      if query = options[:query]
        uri.query = Faraday::NestedParamsEncoder.encode(query)
      end
    end.to_s
  end

  def initialize(options={})
    @url      = URI.parse(options[:url])
    @username = options[:username]

    set_current_user
  end

  def set_current_user
    self.data[:users][username] ||= {
      "email"                => "#{username}@example.org",
      "login"                => username,
      "full_name"            => username,
      "last_created_project" => SecureRandom.hex(2),
    }
  end

  def current_user
    @current_user ||= users.current
  end

  def response(options={})
    body                 = options[:response_body] || options[:body]
    method               = options[:method]        || :get
    params               = options[:params]
    self.last_request    = options[:request_body]
    status               = options[:status]        || 200

    path = options[:path]
    url  = options[:url] || url_for(path, query: params)

    request_headers  = {"Accept"       => "application/xml"}
    response_headers = {"Content-Type" => "application/xml"}.merge(options[:response_headers] || {})

    # request phase
    # * :method - :get, :post, ...
    # * :url    - URI for the current request; also contains GET parameters
    # * :body   - POST parameters for :post/:put requests
    # * :request_headers

    # response phase
    # * :status - HTTP response status code, such as 200
    # * :body   - the response body
    # * :response_headers
    env = Faraday::Env.from(
      :method           => method,
      :url              => URI.parse(url),
      :body             => body,
      :request_headers  => request_headers,
      :response_headers => response_headers,
      :status           => status,
    )

    Faraday::Response::RaiseError.new.on_complete(env) ||
      Faraday::Response.new(env)
  end
end
