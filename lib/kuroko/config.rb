require 'ostruct'

module Kuroko
  class Config < OpenStruct
    def self.new_from_file(file)
      raise ArgumentError("No such readable file: #{file}") unless File.readable?(file)
      config = new
      config.instance_eval(File.open(file, "rb") { |f| f.read }, file, 1)
      config
    end
  end
end
