# frozen_string_literal: true

require 'fileutils'

module GRr
  GRR_DIRECTORY = ENV['GRR_HOME'] || "#{Dir.pwd}/.grr"
  OBJECTS_DIRECTORY = "#{GRR_DIRECTORY}/objects"
  REFS_DIRECTORY = "#{GRR_DIRECTORY}/refs"
  INDEX_PATH = "#{GRR_DIRECTORY}/index"

  class Object
    attr_reader :sha

    def initialize(sha)
      @sha = sha
    end

    def write(&block)
      object_directory = "#{OBJECTS_DIRECTORY}/#{sha[0..1]}"
      FileUtils.mkdir_p object_directory
      object_path = "#{object_directory}/#{sha[2..-1]}"
      File.open(object_path, 'w', &block)
    end
  end
end
