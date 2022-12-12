# frozen_string_literal: true

module GRr
  module Command
    class HashObject
      class << self
        def call(path, write)
          file_contents = File.read path
          sha = Digest::SHA1.hexdigest file_contents
          puts sha
          return unless write

          blob = Zlib::Deflate.deflate file_contents
          object_directory = "#{GRr::OBJECTS_DIRECTORY}/#{sha[0..1]}"
          FileUtils.mkdir_p object_directory
          blob_path = "#{object_directory}/#{sha[2..]}"
          File.open(blob_path, 'w') do |file|
            file.print blob
          end
          puts "Writing object to #{blob_path}"
        end
      end
    end
  end
end
