# frozen_string_literal: true

require 'zlib'
require 'rainbow'

module GRr
  module Command
    class CheckOut
      class << self
        def call(ref:, branch: nil)
          return checkout_branch(ref) if branch? ref
          return checkout_commit(ref) unless ref.nil?

          checkout_new_branch(branch) unless branch.nil?
        end

        def checkout_new_branch(branch)
          puts "creating branch: #{Rainbow(branch).yellow}"
          branch_path = File.join('refs', 'heads', branch)
          ref_path = File.join(GRR_DIRECTORY, branch_path)

          File.open(ref_path, 'w') { |f| f.print current_commit_sha }
          write_head(branch)
        end

        def checkout_branch(branch)
          puts "checking out branch: #{Rainbow(branch).blue}"

          branch_path = File.join(REFS_DIRECTORY, 'heads', branch)
          commit_sha = File.read(branch_path)
          tree_sha = read_object(commit_sha)[0].split[1]

          read_object(tree_sha).each do |line|
            restore_file(line, '.')
          end
          write_head(branch)
        end

        def checkout_commit(sha)
          puts "checking out commit: #{Rainbow(sha).blue}"

          read_object(sha).each do |line|
            restore_file(line, '.')
          end
        end

        def last_commit_object
          read_object(current_commit_sha)[0].split[1]
        end

        private

        def current_commit_sha
          ref_path = File.read(File.join(GRR_DIRECTORY, 'HEAD'))
          branch_path = File.join(GRR_DIRECTORY, ref_path.split(':')[1].strip)
          File.read(branch_path)
        end

        def restore_file(ref, path)
          type, sha, file_name = ref.split
          path = File.join(path, file_name)
          return write_blob(path, sha) if type == 'blob'

          file_refs = read_object(sha)
          file_refs.each do |file_ref|
            restore_file(file_ref, path)
          end
        end

        def read_object(sha)
          path = File.join(OBJECTS_DIRECTORY, sha_path(sha))
          File.readlines(path)
        end

        def write_blob(path, sha)
          puts "restoring file #{Rainbow(path).green} "
          File.open(path, 'w') do |file|
            blob = read_blob(sha)
            file.write(Zlib::Inflate.inflate(blob))
          end
        end

        def read_blob(sha)
          path = File.join(OBJECTS_DIRECTORY, sha_path(sha))
          File.read(path)
        end

        def sha_path(sha)
          File.join(sha[0..1], sha[2..])
        end

        def branch?(branch)
          return false if branch.nil?

          File.exist? File.join(REFS_DIRECTORY, 'heads', branch)
        end

        def write_head(branch)
          File.open(File.join(GRR_DIRECTORY, 'HEAD'), 'w') do |f|
            f.puts "ref: refs/heads/#{branch}"
          end
        end
      end
    end
  end
end
