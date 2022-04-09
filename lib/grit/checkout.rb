# frozen_string_literal: true

require 'zlib'

module GRit
  module Command
    class CheckOut
      class << self
        def call(sha)
          puts "checking out #{sha}"
          commit_object.each do |line|
            type, sha, file_name = line.split
            restore_file(sha, "./tmp/#{file_name}") if type == 'blob'
          end
        end

        def commit_object
          ref_path = File.read(File.join(GRIT_DIRECTORY, 'HEAD'))
          sha_path = File.join(GRIT_DIRECTORY, ref_path.split(':')[1].strip)

          commit_sha = File.read(sha_path)
          commit_tree_sha = read_object(commit_sha)[0].split[1]
          read_object(commit_tree_sha)
        end

        def restore_file(sha, path)
          File.open(path, 'w') do |file|
            blob = read_blob(sha)

            file.write(Zlib::Inflate.inflate(blob))
          end
        end

        def read_object(sha)
          path = File.join(OBJECTS_DIRECTORY, sha_path(sha))
          File.readlines(path)
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
