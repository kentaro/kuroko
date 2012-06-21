require 'cinch'

module Kuroko
  module IRC
    class Bot < Cinch::Bot
      attr_reader :observer

      def initialize(observer, &block)
        super(&block)
        @observer = observer
      end
    end

    class Handler
      include Cinch::Plugin

      match /add (.+)/, method: :add
      def add(message, url)
        channel = message.channel.instance_variable_get(:@name)

        if bot.observer.has_feed?(channel, url)
          message.reply("Already exists: #{url}")
        else
          bot.observer.add_feed(channel, url)
          message.reply "Added: #{url}"
        end
      end

      match /del (.+)/, method: :del
      def del(message, url)
        channel = message.channel.instance_variable_get(:@name)

        if bot.observer.has_feed?(channel, url)
          bot.observer.delete_feed(channel, url)
          message.reply("Deleted: #{url}")
        else
          message.reply("No such feed: #{url}")
        end
      end

      match /list/, method: :list
      def list(message)
        channel = message.channel.instance_variable_get(:@name)

        if bot.observer.feeds_for(channel).any?
          bot.observer.feeds(channel).each do |feed|
            message.reply(feed[:url])
          end
        else
          message.reply("No feed yet")
        end
      end
    end
  end
end
