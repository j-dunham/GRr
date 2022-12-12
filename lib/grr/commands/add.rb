# frozen_string_literal: true

require 'digest'
require 'zlib'
require 'fileutils'
require_relative '../models/object'

module GRr
  module Command
    class Add
      class << self
        def call(path)
          return puts 'Not an GRr project' unless Dir.exist? GRr::GRR_DIRECTORY

          file_contents = File.read path
          sha = Digest::SHA1.hexdigest file_contents
          blob = Zlib::Deflate.deflate file_contents
          object_directory = "#{GRr::OBJECTS_DIRECTORY}/#{sha[0..1]}"
          FileUtils.mkdir_p object_directory
          blob_path = "#{object_directory}/#{sha[2..]}"

          File.open(blob_path, 'w') do |file|
            file.print blob
          end

          File.open(GRr::INDEX_PATH, 'a') do |file|
            file.puts "#{sha} #{path}"
          end
        end
      end
    end
  end
end
