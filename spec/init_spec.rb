# frozen_string_literal: true

RSpec.describe GRr::Command::Init do
  describe '.call' do
    after do
      FileUtils.rm_rf('tmp/.grr')
    end

    it 'creates .grr directory' do
      GRr::Command::Init.call
      expect(Dir.exist?('tmp/.grr')).to be_truthy
    end

    it 'creates .grr/objects directory' do
      GRr::Command::Init.call
      expect(Dir.exist?('tmp/.grr/objects')).to be_truthy
    end

    it 'creates .grr/objects/info directory' do
      GRr::Command::Init.call
      expect(Dir.exist?('tmp/.grr/objects/info')).to be_truthy
    end

    it 'creates .grr/objects/pack directory' do
      GRr::Command::Init.call
      expect(Dir.exist?('tmp/.grr/objects/pack')).to be_truthy
    end

    it 'creates .grr/refs directory' do
      GRr::Command::Init.call
      expect(Dir.exist?('tmp/.grr/refs')).to be_truthy
    end

    it 'creates .grr/refs/heads directory' do
      GRr::Command::Init.call
      expect(Dir.exist?('tmp/.grr/refs/heads')).to be_truthy
    end

    it 'creates .grr/refs/tags directory' do
      GRr::Command::Init.call
      expect(Dir.exist?('tmp/.grr/refs/tags')).to be_truthy
    end

    it 'creates .grr/HEAD file' do
      GRr::Command::Init.call
      expect(File.exist?('tmp/.grr/HEAD')).to be_truthy
    end

    it 'creates .grr/HEAD file with ref: refs/heads/main' do
      GRr::Command::Init.call
      expect(File.read('tmp/.grr/HEAD')).to eq("ref: refs/heads/main\n")
    end
  end
end
