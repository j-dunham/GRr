# frozen_string_literal: true

require 'fileutils'
require_relative 'object'

module GRit
  module Command
    class Init
      class << self
        def call
          return puts 'GRit is already initialized' if Dir.exist? GRit::GRIT_DIRECTORY

          Dir.mkdir GRit::GRIT_DIRECTORY
          build_objects_directory
          build_refs_directory
          build_head
          puts 'GRit initialized!'
        end

        def build_objects_directory
          %w[info pack].each do |path|
            FileUtils.mkdir_p(File.join(GRit::OBJECTS_DIRECTORY, path))
          end
        end

        def build_refs_directory
          %w[heads tags].each do |path|
            FileUtils.mkdir_p(File.join(GRit::REFS_DIRECTORY, path))
          end
        end

        def build_head
          File.open(File.join(GRit::GRIT_DIRECTORY, 'HEAD'), 'w') do |file|
            file.puts 'ref: refs/heads/main'
          end
        end
      end
    end
  end
end
