# frozen_string_literal: true

require 'digest'
require 'time'
require_relative 'object'

module GRr
  module Command
    class Commit
      class << self
        def call(message)
          return 'Nothing to commit' if index_files.count.zero?

          root_sha = build_tree('root', index_tree)
          commit_sha = build_commit(tree: root_sha, message: message)
          update_ref(commit_sha: commit_sha)
          clear_index
        end

        def index_files
          File.open(GRr::INDEX_PATH).each_line
        end

        def index_tree
          index_files.each_with_object({}) do |line, obj|
            sha, path = line.split
            segments = path.split('/')
            segments.reduce(obj) do |memo, s|
              if s == segments.last
                memo[segments.last] = sha
                memo
              else
                memo[s] ||= {}
                memo[s]
              end
            end
          end
        end

        def build_tree(name, tree)
          sha = Digest::SHA1.hexdigest(Time.now.iso8601 + name)
          object = GRr::Object.new(sha)
          object.write do |file|
            tree.each do |key, value|
              if value.is_a? Hash
                dir_sha = build_tree(key, value)
                file.puts "tree #{dir_sha} #{key}"
              else
                file.puts "blob #{value} #{key}"
              end
            end
          end

          sha
        end

        def build_commit(tree:, message:)
          committer = 'user'
          sha = Digest::SHA1.hexdigest(Time.now.iso8601 + committer)
          object = GRr::Object.new(sha)
          parent = parent_ref

          object.write do |file|
            file.puts "tree #{tree}"
            file.puts "parent #{parent}" unless parent.nil?
            file.puts "author #{committer}"
            file.puts
            file.puts message
          end

          sha
        end

        def current_branch
          File.read("#{GRr::GRR_DIRECTORY}/HEAD").strip.split.last
        end

        def parent_ref
          path = "#{GRr::GRR_DIRECTORY}/#{current_branch}"
          File.read(path) if File.exist? path
        end

        def update_ref(commit_sha:)
          File.open("#{GRr::GRR_DIRECTORY}/#{current_branch}", 'w') do |file|
            file.print commit_sha
          end
        end

        def clear_index
          File.truncate GRr::INDEX_PATH, 0
        end
      end
    end
  end
end
