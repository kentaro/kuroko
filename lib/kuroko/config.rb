require 'yaml'

module Kuroko
  class Config
    def self.load(file)
      YAML.load_file(file)
    end
  end
end
