#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'

require_relative './lib/grit/add'
require_relative './lib/grit/init'
require_relative './lib/grit/commit'
require_relative './lib/grit/log'

module GRit
  class CLI < Thor
    desc 'init', 'initialize GRit directories/files'
    def init
      Init.call
    end

    desc 'add', 'adds file to staging'
    def add(path)
      Add.call(path)
    end

    desc 'commit', 'commit staged files'
    def commit(message)
      Commit.call(message)
    end

    desc 'log', 'show commit history'
    def log
      Log.call
    end
  end
end

GRit::CLI.start
