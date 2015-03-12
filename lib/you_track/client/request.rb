class YouTrack::Client::Request
  def find(collection, id, options={})
    service.data.fetch(collection)[id] ||
      service.response(status: 404, body: {"error" => "#{collection.to_s.gsub(/s\Z/, "").capitalize} not found."})
  end
end
