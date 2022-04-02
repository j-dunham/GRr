# frozen_string_literal: true

require 'digest'
require 'zlib'
require 'fileutils'
require_relative 'object'

module GRit
  class Add
    class << self
      def call(path)
        return puts 'Not an GRit project' unless Dir.exist? GRit::GRIT_DIRECTORY

        file_contents = File.read path
        sha = Digest::SHA1.hexdigest file_contents
        blob = Zlib::Deflate.deflate file_contents
        object_directory = "#{GRit::OBJECTS_DIRECTORY}/#{sha[0..1]}"
        FileUtils.mkdir_p object_directory
        blob_path = "#{object_directory}/#{sha[2..-1]}"

        File.open(blob_path, 'w') do |file|
          file.print blob
        end

        File.open(GRit::INDEX_PATH, 'a') do |file|
          file.puts "#{sha} #{path}"
        end
      end
    end
  end
end
