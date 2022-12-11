# frozen_string_literal: true

require_relative '../lib/grr/commit'

RSpec.describe GRr::Command::Commit do
  describe '.index_tree' do
    let(:index_tree) do
      {
        'lib' => {
          'grr' => {
            'commit.rb' => 'd1e1a6a2b6c2e1a6a2b6c2e1a6a2b6c2e1a6a2b'
          }
        },
        'spec' => {
          'commit_spec.rb' => 'd1e1a6a2b6c2e1a6a2b6c2e1a6a2b6c2e1a6a2b'
        }
      }
    end

    before do
      allow(GRr::Command::Commit).to receive(:index_files).and_return(
        [
          'd1e1a6a2b6c2e1a6a2b6c2e1a6a2b6c2e1a6a2b lib/grr/commit.rb',
          'd1e1a6a2b6c2e1a6a2b6c2e1a6a2b6c2e1a6a2b spec/commit_spec.rb'
        ]
      )
    end

    it 'returns a tree' do
      expect(GRr::Command::Commit.index_tree).to eq(index_tree)
    end
  end

  describe '.build_tree' do
    let(:tree) do
      {
        'lib' => {
          'grr' => {
            'commit.rb' => 'd1e1a6a2b6c2e1a6a2b6c2e1a6a2b6c2e1a6a2b'
          }
        },
        'spec' => {
          'commit_spec.rb' => 'd1e1a6a2b6c2e1a6a2b6c2e1a6a2b6c2e1a6a2b'
        }
      }
    end

    before do
      allow(GRr::Command::Commit).to receive(:index_tree).and_return(tree)
    end

    it 'returns a sha' do
      allow(Time).to receive(:now).and_return(Time.parse('2019-01-01 00:00:00'))

      expect(GRr::Command::Commit.build_tree('root', tree)).to eq('827b1ca08965dac7a94b631b9473e8445a4ec904')
    end
  end
end
