require 'thread'

require 'kuroko/config'
require 'kuroko/httpd'
require 'kuroko/irc_client'

module Kuroko
  class Core
    attr_reader :config

    def initialize(file)
      # @config = ::Kuroko::Config.new_from_file(file)
      @irc   = IRCClient.new(self)
      @httpd = HTTPD.new(self)
    end

    def update(message)
      @irc.notify(message)
    end

    def run
      trap('INT') { exit! }
      Thread.abort_on_exception = true

      [@irc, @httpd].map { |component|
        Thread.start(component) { component.run }
      }.each(&:join)
    end
  end
end
