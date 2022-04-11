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

    method_options last: :boolean, b: :string
    desc 'checkout', 'checkout a commit sha or branch'
    def checkout(ref = nil)
      return Command::CheckOut.call(ref: nil, branch: options.b) if options.b

      ref = Command::CheckOut.last_commit_object if options.last
      return say 'No reference provided..', :red if ref.nil?

      Command::CheckOut.call(ref: ref, branch: nil)
    end
  end
end

GRit::CLI.start
