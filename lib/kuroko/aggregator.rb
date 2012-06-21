require 'feedzirra'

module Kuroko
  class Aggregator
    def initialize(observer)
      @observer = observer
    end

    def aggregate(feeds)
      channel_for = feeds.keys.each_with_object({}) do |key, result|
        feeds[key].each do |feed|
          result[feed[:url]] = key
        end
      end

      Feedzirra::Feed.fetch_and_parse(
        channel_for.keys,
        on_success: ->(url, feed) {
          feed.entries.each do |entry|
            begin
              @observer.update(
                type:    :notice,
                channel: channel_for[url],
                message: "[#{entry.title}] #{entry.summary} -- #{entry.url}"
              )
            rescue => error
              @observer.update(
                type:    :notice,
                channel: channel_for[url],
                message: "Error: #{error}")
            end
          end
        },
        on_failure: ->(url, response_code, response_header, response_body) {
          @observer.update(
            type:    :notice,
            channel: channel_for[url],
            message: "Failed to fetch feed: #{response_code} #{url} ")
        }
      )
    end

    def run
      loop do
        feeds = @observer.feeds

        if feeds.keys.inject(0) { |r, k| r += feeds[k].size } > 0
          aggregate(feeds)
        end

        sleep @observer.config['aggregator']['interval']
      end
    end
  end
end
