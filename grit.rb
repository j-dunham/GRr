#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'

require_relative './lib/grit/add'
require_relative './lib/grit/init'
require_relative './lib/grit/commit'

class CLI < Thor
  desc 'init', 'initialize GRit directories/files'
  def init
    GRit::Init.call
  end

  desc 'add', 'adds file to staging'
  def add(path)
    GRit::Add.call(path)
  end

  desc 'commit', 'commit staged files'
  def commit(message)
    GRit::Commit.call(message)
  end
end

CLI.start
