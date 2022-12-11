# frozen_string_literal: true

require_relative('../lib/grr/log')

RSpec.describe GRr::Command::Log do
  let(:commit_message) do
    ['tree 12132', 'parent 12312', 'author user', '', 'added files']
  end

  it 'should log to stdout' do
    allow(GRr::Command::Log).to receive(:commits).and_return([commit_message])
    expect { GRr::Command::Log.call }.to output("\e[33m12132\e[0m added files\n").to_stdout
  end
end
