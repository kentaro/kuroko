require 'sinatra'

module Kuroko
  class HTTPD
    def initialize(observer)
      @observer = observer
    end

    def run
      App.set(:observer, @observer)
      Rack::Handler::WEBrick.run(App.new, Port: 8080)#observer.config.httpd.port || 4979)
    end
  end

  class App < Sinatra::Base
    post "/join" do
      settings.observer.update(type: :join, channel: params[:channel])
      "Joined #{params[:channel]}"
    end

    post "/leave" do
      settings.observer.update(type: :leave, channel: params[:channel])
      "Leaved #{params[:channel]}"
    end

    post "/privmsg" do
      settings.observer.update(type: :privmsg, channel: params[:channel], message: params[:message])
      "Sent a message (#{params[:message]}) to #{params[:channel]}"
    end

    post "/notice" do
      settings.observer.update(type: :notice, channel: params[:channel], message: params[:message])
      "Sent a notice (#{params[:message]}) to #{params[:channel]}"
    end
  end
end
