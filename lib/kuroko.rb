require 'kuroko/core'
require 'kuroko/version'

module Kuroko
  def self.run(file)
    Core.new(file).run
  end
end
