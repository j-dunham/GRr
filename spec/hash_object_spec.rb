# frozen_string_literal: true

require_relative '../lib/grr/commands/hash_object'

RSpec.describe GRr::Command::HashObject do
  describe '.hash_object' do
    after do
      FileUtils.rm_rf('tmp/.grr')
    end

    it 'outputs hash when write is false' do
      expect do
        GRr::Command::HashObject.call('spec/fixtures/add_file.rb', false)
      end.to output("fa156bd88b2daaf55ef08f591792448a86b61e49\n").to_stdout
    end

    it 'writes object to .grr/objects directory when write is true' do
      expect do
        GRr::Command::HashObject.call('spec/fixtures/add_file.rb', true)
      end.to output(
        "fa156bd88b2daaf55ef08f591792448a86b61e49\nWriting object to tmp/.grr/objects/fa/156bd88b2daaf55ef08f591792448a86b61e49\n"
      ).to_stdout
      expect(File.exist?('tmp/.grr/objects/fa/156bd88b2daaf55ef08f591792448a86b61e49')).to be_truthy
    end
  end
end
