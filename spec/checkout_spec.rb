# frozen_string_literal: true

require_relative '../lib/grr/commands/checkout'

RSpec.describe GRr::Command::CheckOut do
  describe '.call' do
    let(:branch) { 'test' }
    let(:ref) { nil }

    context 'when ref is nil' do
      it 'checks out new branch' do
        expect(GRr::Command::CheckOut).to receive(:checkout_new_branch).with(branch)
        GRr::Command::CheckOut.call(ref: ref, branch: branch)
      end
    end

    context 'when ref is branch' do
      let(:ref) { 'test' }

      it 'checks out branch' do
        allow(GRr::Command::CheckOut).to receive(:branch?).with(ref).and_return(true)
        expect(GRr::Command::CheckOut).to receive(:checkout_branch).with(ref)
        GRr::Command::CheckOut.call(ref: ref, branch: branch)
      end
    end

    context 'when ref is commit' do
      let(:ref) { '5b4c3b70ed776803408939a6652386a0b0506d43' }

      it 'checks out commit' do
        expect(GRr::Command::CheckOut).to receive(:checkout_commit).with(ref)
        GRr::Command::CheckOut.call(ref: ref, branch: branch)
      end
    end
  end

  describe '.checkout_new_branch' do
    let(:branch) { 'test' }
    let(:commit_sha) { '5b4c3b70ed776803408939a6652386a0b0506d43' }

    before do
      allow(GRr::Command::CheckOut).to receive(:current_commit_sha).and_return(commit_sha)
    end

    it 'creates new branch' do
      file_spy = spy('File')
      allow(File).to receive(:open).with('tmp/.grr/refs/heads/test', 'w').and_yield(file_spy)
      expect(file_spy).to receive(:print).with(commit_sha)
      allow(File).to receive(:open).with('tmp/.grr/HEAD', 'w')
      GRr::Command::CheckOut.checkout_new_branch(branch)
    end

    it 'updates HEAD to point to branch' do
      allow(File).to receive(:open).with('tmp/.grr/refs/heads/test', 'w').and_return('ref: refs/heads/master')
      expect(GRr::Command::CheckOut).to receive(:write_head).with(branch)
      GRr::Command::CheckOut.checkout_new_branch(branch)
    end
  end

  describe '.checkout_branch' do
    let(:branch) { 'test' }
    let(:tree_sha) { '5b4c3b70ed776803408939a6652386a0b0506d43' }

    before do
      allow(File).to receive(:read).with('tmp/.grr/refs/heads/test').and_return(tree_sha)
      allow(GRr::Command::CheckOut).to receive(:read_object).with(tree_sha).and_return(
        ['tree 5b4c3b70ed776803408939a6652386a0b0506d43 README.md']
      )
      allow(GRr::Command::CheckOut).to receive(:read_object).with('5b4c3b70ed776803408939a6652386a0b0506d43').and_return(
        ['blob 5b4c3b70ed776803408939a6652386a0b0506d43 README.md']
      )
    end

    it "call restore_file for each file in branch's tree" do
      expect(GRr::Command::CheckOut).to receive(:restore_file).with(
        'blob 5b4c3b70ed776803408939a6652386a0b0506d43 README.md', '.'
      )
      GRr::Command::CheckOut.checkout_branch(branch)
    end

    it 'updates HEAD with branch' do
      allow(GRr::Command::CheckOut).to receive(:restore_file)

      expect(GRr::Command::CheckOut).to receive(:write_head).with(branch)
      GRr::Command::CheckOut.checkout_branch(branch)
    end
  end

  describe '.checkout_commit' do
    let(:commit_sha) { '5b4c3b70ed776803408939a6652386a0b0506d43' }
    let(:tree_sha) { '5b4c3b70ed776803408939a6652386a0b0506d43' }

    before do
      allow(GRr::Command::CheckOut).to receive(:read_object).with('5b4c3b70ed776803408939a6652386a0b0506d43').and_return(
        ['blob 5b4c3b70ed776803408939a6652386a0b0506d43 README.md']
      )
    end

    it "call restore_file for each file in commit's tree" do
      expect(GRr::Command::CheckOut).to receive(:restore_file).with(
        'blob 5b4c3b70ed776803408939a6652386a0b0506d43 README.md', '.'
      )
      GRr::Command::CheckOut.checkout_commit(commit_sha)
    end
  end
end
