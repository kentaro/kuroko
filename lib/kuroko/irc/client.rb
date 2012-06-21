require 'kuroko/irc/bot'
require 'cinch/helpers'

module Kuroko
  module IRC
    class Client
      include Cinch::Helpers

      def initialize(observer)
        @observer = observer
        @bot      = Bot.new(observer) do
          configure do |c|
            c.server          = "irc.freenode.org"
            c.nick            = 'kuroko'
            c.channels        = ["#antipop"]
            c.plugins.plugins = [Handler]
          end
        end
      end

      def notify(message)
        if @bot.channels.include?(message[:channel])
          if (message[:type] =~ /(privmsg|notice)/i)
            Channel(message[:channel]).safe_msg(
              message[:message],
              message[:type] =~ /notice/i
            )
          else
            @bot.irc.send("#{message[:type]} #{message[:channel]}")
          end
        end
      end

      def run
        @bot.start
      end
    end
  end
end
