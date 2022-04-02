# frozen_string_literal: true

module GRit
  class Log
    class << self
      def call
        show_commit(current_commit_sha)
      end

      def show_commit(sha)
        dir = sha[0..1]
        file = sha[2..-1]
        File.open(File.join(OBJECTS_DIRECTORY, dir, file)) do |f|
          puts f.read
        end
      end

      def current_commit_sha
        ref_path = File.read(File.join(GRIT_DIRECTORY, 'HEAD'))
        File.read(File.join(GRIT_DIRECTORY, ref_path.split(':')[1].strip))
      end
    end
  end
end
