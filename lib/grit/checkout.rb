# frozen_string_literal: true

module GRit
  module Command
    class CheckOut
      class << self
        def call(sha)
          puts "checking out #{sha}"
        end
      end
    end
  end
end
