require 'cinch/helpers'
require 'kuroko/irc/bot'

module Kuroko
  module IRC
    class Client
      include Cinch::Helpers
      attr_reader :bot

      def initialize(observer)
        @observer = observer
        @bot      = Bot.new(observer)

        @bot.config.server          = @observer.config['irc']['server']
        @bot.config.nick            = @observer.config['irc']['nick']
        @bot.config.channels        = @observer.config['irc']['channels']
        @bot.config.plugins.plugins = [Handler]
      end

      def notify(message)
        channel = Channel(message[:channel])

        if @bot.channels.include?(message[:channel])
          if message[:type] =~ /privmsg|notice/i
            channel.safe_msg(
              message[:message],
              message[:type] =~ /notice/i
            )
          else
            channel.__send__(message[:type].downcase)
          end
        end
      end

      def run
        @bot.start
      end
    end
  end
end
