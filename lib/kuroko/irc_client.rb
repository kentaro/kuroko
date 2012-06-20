require 'cinch'

module Kuroko
  class IRCClient
    attr_reader :observer, :bot

    def initialize(observer)
      @observer = observer
    end

    def notify(message)
      if @bot.channels.include?(message[:channel])
        @bot.irc.send("#{message[:type]} #{message[:channel]} #{message[:message] || ''}")
      end
    end

    def run
      @bot = Cinch::Bot.new do
        configure do |c|
          c.server = "irc.freenode.org"
          c.channels = ["#antipop"]
          c.plugins.plugins = [Handler]
        end
      end

      @bot.start
    end
  end

  class Handler
    include Cinch::Plugin
    attr_reader :storage

    def initialize(*args)
      super
      @storage = {}
    end

    match /add (.+)/, method: :add
    def add(message, url)
      if storage.has_key? url
        message.reply "Already exists: #{url}"
      else
        storage[url] = nil
        message.reply "Added: #{url}"
      end
    end

    match /del (.+)/, method: :del
    def del(message, url)
      if storage.has_key? url
        storage.delete(url)
        message.reply "Deleted: #{url}"
      else
        message.reply "No such feed: #{url}"
      end
    end

    match /list/, method: :list
    def list(message)
      if storage.any?
        storage.keys.each do |url|
          message.reply "#{url}"
        end
      else
        message.reply "No feed yet"
      end
    end
  end
end
