#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'

require_relative './lib/grit/add'
require_relative './lib/grit/init'
require_relative './lib/grit/commit'

class CLI < Thor
  desc 'init', 'initialize GRit directories/files'
  def init
    GRit::Init.call_init
  end

  desc 'add', 'adds file to staging'
  def add(path)
    GRit::Add.call_add(path)
  end

  desc 'commit', 'commit staged files'
  def commit
    GRit::Commit.call_commit
  end
end

CLI.start
