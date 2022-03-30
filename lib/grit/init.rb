# frozen_string_literal: true

require 'fileutils'
require_relative 'object'

module GRit
  class Init
    class << self
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

      def call_init
        return puts 'GRit is already initialized' if Dir.exist? GRit::GRIT_DIRECTORY

        Dir.mkdir GRit::GRIT_DIRECTORY
        build_objects_directory
        build_refs_directory
        build_head
        puts 'GRit initialized!'
      end
    end
  end
end
