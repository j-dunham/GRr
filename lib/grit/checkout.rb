# frozen_string_literal: true

require 'zlib'
require 'rainbow'

module GRit
  module Command
    class CheckOut
      class << self
        def call(sha)
          # TODO: find correct commit
          puts "checking out commit: #{Rainbow(sha).blue}"
          commit_object.each do |line|
            restore_file(line, '.')
          end
        end

        def commit_object
          ref_path = File.read(File.join(GRIT_DIRECTORY, 'HEAD'))
          sha_path = File.join(GRIT_DIRECTORY, ref_path.split(':')[1].strip)

          commit_sha = File.read(sha_path)
          commit_tree_sha = read_object(commit_sha)[0].split[1]
          read_object(commit_tree_sha)
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
