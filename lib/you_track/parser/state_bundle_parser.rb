class YouTrack::Parser::StateBundleParser < YouTrack::Parser::Base
  def parse
    bundle = raw["stateBundle"]

    states = bundle.delete("state")

    bundle["states"] = states.inject([]) { |r,h|
      r << {
        "resolved" => h["isResolved"],
        "value"    => h["__content__"],
      }
    }

    bundle
  end
end
