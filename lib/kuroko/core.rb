require 'thread'

require 'kuroko/config'
require 'kuroko/httpd'
require 'kuroko/irc/client'
require 'kuroko/aggregator'

module Kuroko
  class Core
    attr_reader :config, :feeds

    def initialize(file)
      # @config = ::Kuroko::Config.new_from_file(file)
      @irc        = IRC::Client.new(self)
      @httpd      = HTTPD.new(self)
      @aggregator = Aggregator.new(self)
      @feeds      = {}
    end

    def run
      trap('INT') { exit! }
      Thread.abort_on_exception = true

      [@irc, @httpd, @aggregator].map { |component|
        Thread.start(component) { component.run }
      }.each(&:join)
    end

    def update(message)
      @irc.notify(message)
    end

    def feeds_for(channel)
      @feeds[channel] ||= []
      @feeds[channel]
    end

    def add_feed(channel, url)
      unless has_feed?(channel, url)
        feeds_for(channel).push(url: url)
      end
    end

    def delete_feed(channel, url)
      feeds_for(channel).delete_if do |feed|
        feed[:url] == url
      end
    end

    def has_feed?(channel, url)
      feeds_for(channel).any? do |feed|
        feed[:url] == url
      end
    end
  end
end
