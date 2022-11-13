#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'
require 'pry'

require_relative './lib/grr/add'
require_relative './lib/grr/init'
require_relative './lib/grr/commit'
require_relative './lib/grr/log'
require_relative './lib/grr/checkout'
require_relative './lib/grr/hash_object'

module GRr
  class CLI < Thor
    desc 'init', 'initialize GRr directories/files'
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

    desc 'hash-object', 'reports the GRr object id of a file and optionally writes it to the object database'
    options w: :boolean
    def hash_object(path)
      Command::HashObject.call(path, options[:w])
    end
  end
end

GRr::CLI.start
