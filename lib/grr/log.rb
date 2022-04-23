# frozen_string_literal: true

require 'rainbow'

module GRr
  module Command
    class Log
      class << self
        def call
          commits&.each do |commit|
            puts "#{Rainbow(commit[0].split[1].strip).yellow} #{commit[-1]}"
          end
        end

        def commits(sha: root_sha, arr: [])
          return if sha.nil?

          commit = entry(sha)
          arr << commit
          return arr if parent_sha(commit).nil?

          commits(arr: arr, sha: parent_sha(commit))
        end

        def entry(sha)
          path = File.join(OBJECTS_DIRECTORY, sha[0..1], sha[2..-1])
          File.readlines(path)
        end

        def root_sha
          ref_path = File.read(File.join(GRR_DIRECTORY, 'HEAD'))
          sha_path = File.join(GRR_DIRECTORY, ref_path.split(':')[1].strip)
          return unless File.exist? sha_path

          File.read(sha_path)
        end

        def parent_sha(commit)
          parent_line = commit.find { |line| line.start_with? 'parent' }
          return if parent_line.nil?

          parent_line.split[1]
        end
      end
    end
  end
end
