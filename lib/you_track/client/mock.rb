class YouTrack::Client::Mock
  attr_reader :url, :username

  def self.data
    @data ||= Hash.new { |h,k|
      h[k] = {
        :issues   => {},
        :comments => {},
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
      File.join(self.url, "/rest", path.to_s)
    ).tap do |uri|
      if query = options[:query]
        uri.query = Faraday::NestedParamsEncoder.encode(query)
      end
    end.to_s
  end

  def initialize(options={})
    @url = options[:url]
    @username = options[:username]
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
    response_headers = {"Content-Type" => "application/xml"}

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
