# frozen_string_literal: true

require 'fileutils'
require_relative 'object'

module GRr
  module Command
    class Init
      class << self
        def call
          return puts 'GRr is already initialized' if Dir.exist? GRr::GRR_DIRECTORY

          Dir.mkdir GRr::GRR_DIRECTORY
          build_objects_directory
          build_refs_directory
          build_head
          puts 'GRR initialized!'
        end

        def build_objects_directory
          %w[info pack].each do |path|
            FileUtils.mkdir_p(File.join(GRr::OBJECTS_DIRECTORY, path))
          end
        end

        def build_refs_directory
          %w[heads tags].each do |path|
            FileUtils.mkdir_p(File.join(GRr::REFS_DIRECTORY, path))
          end
        end

        def build_head
          File.open(File.join(GRr::GRR_DIRECTORY, 'HEAD'), 'w') do |file|
            file.puts 'ref: refs/heads/main'
          end
        end
      end
    end
  end
end
