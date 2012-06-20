require 'feedzirra'

module Kuroko
  class Feed
    def self.fetch(urls, on_success = ->() {}, on_failure = ->() {})
      Feedzirra::Feed.fetch_and_parse urls, on_success: on_success, on_failure: on_failure
    end
  end
end
