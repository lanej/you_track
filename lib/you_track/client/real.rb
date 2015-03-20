class YouTrack::Client::Real
  attr_reader :url, :connection, :adapter, :username, :authenticated

  def initialize(options={})
    options.merge!(YouTrack.defaults)

    requires(options, :url, :username, :password)

    @url           = URI.parse(options[:url])
    adapter        = options[:adapter] || Faraday.default_adapter
    logger         = options[:logger]  || Logger.new(nil)
    custom_builder = options[:builder] || lambda { |*| }

    @username, @password = options.values_at(:username, :password)
    @authenticated, @authenticating = false, false

    @authenticate_mutex = Mutex.new

    connection_options = options[:connection_options] || {}

    @connection = Faraday.new({url: @url}.merge(connection_options)) do |builder|
      # response
      builder.response :xml, content_type: /\bxml$/

      # request
      builder.request :retry,
        :max                 => 5,
        :interval            => 1,
        :interval_randomness => 0.1,
        :backoff_factor      => 2

      builder.use :cookie_jar
      builder.request :multipart

      builder.use Faraday::Response::RaiseError
      builder.response :logger, logger

      custom_builder.call(builder)

      builder.adapter(*adapter)
    end
  end

  def requires(options, *required)
    missing = required.map do |required_param|
      required_param if options[required_param].nil?
    end.compact
    raise RuntimeError, "Missing required options: #{missing.inspect}" unless missing.empty?
  end

  def authenticate!
    # @note first request gets the cookie
    if !@authenticated && !@authenticating

      @authenticate_mutex.synchronize {
        next if @authenticated
        @authenticating = true

        begin
          login(@username, @password)
        ensure
          @authenticating = false
        end

        @authenticated = true
      }
    end
  end

  def request(options={})
    authenticate!

    method    = options[:method] || :get
    query     = options[:query]
    url       = URI.parse(options[:url] || File.join(self.url.to_s, "/rest", options.fetch(:path)))
    url.query = query.map { |k,v| "#{URI.escape(k)}=#{URI.escape(v.to_s)}" }.join('&') if query
    params    = options[:params] || {}
    body      = options[:body]
    headers   = options[:headers] || {}
    parser    = options[:parser]

    headers["Content-Type"] ||= if body.nil?
                                  if !params.empty?
                                    "application/x-www-form-urlencoded"
                                  else # Rails infers a Content-Type and we must set it here for the canonical string to match
                                    "text/plain"
                                  end
                                end

    response = @connection.send(method) do |req|
      req.url(url.to_s)
      req.headers.merge!(headers)
      req.params.merge!(params)
      req.body = body
    end

    response.env.body = parser.new(response.body).parse if parser

    response
  end

  def current_user
    @current_user ||= users.current
  end
end
