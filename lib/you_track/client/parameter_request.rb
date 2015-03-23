module YouTrack::Client::ParameterRequest
  attr_reader :params

  def setup(params)
    @params = Cistern::Hash.stringify_keys(params)
  end

  def _mock(params={})
    setup(params)
    mock
  end

  def _real(params={})
    setup(params)
    real
  end
end
