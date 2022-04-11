# frozen_string_literal: true

require 'zlib'
require 'rainbow'

module GRit
  module Command
    class CheckOut
      class << self
        def call(sha:, branch: nil)
          checkout_commit(sha) unless sha.nil?

          checkout_new_branch(branch) unless branch.nil?
        end

        def checkout_new_branch(branch)
          puts "creating branch: #{Rainbow(branch).yellow}"
          branch_path = File.join('refs', 'heads', branch)
          ref_path = File.join(GRIT_DIRECTORY, branch_path)
          head_path = File.join(GRIT_DIRECTORY, 'HEAD')

          File.open(ref_path, 'w') { |file| file.print current_commit_sha }

          File.open(head_path, 'w') { |file| file.puts "ref: #{branch_path}" }
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

        def current_commit_sha
          ref_path = File.read(File.join(GRIT_DIRECTORY, 'HEAD'))
          branch_path = File.join(GRIT_DIRECTORY, ref_path.split(':')[1].strip)
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
          File.join(sha[0..1], sha[2..-1])
        end
      end
    end
  end
end
