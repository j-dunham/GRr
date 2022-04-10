#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'

require_relative './lib/grit/add'
require_relative './lib/grit/init'
require_relative './lib/grit/commit'
require_relative './lib/grit/log'
require_relative './lib/grit/checkout'

module GRit
  class CLI < Thor
    desc 'init', 'initialize GRit directories/files'
    def init
      Command::Init.call
    end

    desc 'add', 'adds file to staging'
    def add(path)
      Command::Add.call(path)
    end

    desc 'commit', 'commit staged files'
    def commit(message)
      Command::Commit.call(message)
    end

    desc 'log', 'show commit history'
    def log
      Command::Log.call
    end

    desc 'checkout', 'checkout a commit'
    def checkout(sha)
      sha ||= nil
      Command::CheckOut.call(sha: sha)
    end
  end
end

GRit::CLI.start
