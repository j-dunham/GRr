# frozen_string_literal: true

require 'fileutils'

module GRit
  GRIT_DIRECTORY = "#{Dir.pwd}/.grit"
  OBJECTS_DIRECTORY = "#{GRIT_DIRECTORY}/objects"
  REFS_DIRECTORY = "#{GRIT_DIRECTORY}/refs"
  INDEX_PATH = "#{GRIT_DIRECTORY}/index"

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
