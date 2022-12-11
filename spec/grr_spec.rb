# frozen_string_literal: true

require 'fileutils'
require_relative '../grr'

RSpec.describe GRr::CLI do
  let(:cli) { GRr::CLI.new }

  before do
    FileUtils.rm_rf ENV.fetch('GRR_HOME', nil)
  end

  after do
    FileUtils.rm_rf ENV.fetch('GRR_HOME', nil)
  end

  describe 'when calling init' do
    it 'prints to stdout' do
      expect { cli.init }.to output("GRR initialized!\n").to_stdout
    end
  end
end
