require_relative '../lib/grr/add'

RSpec.describe GRr::Command::Add do
  describe '.call' do
    let(:file) { 'spec/fixtures/add_file.rb' }
    let(:blob_path) { 'tmp/.grr/objects/5b/4c3b70ed776803408939a6652386a0b0506d43' }

    context 'when GRr project is not initialized' do
      it 'returns error message' do
        allow(Dir).to receive(:exist?).with(GRr::GRR_DIRECTORY).and_return(false)
        expect { GRr::Command::Add.call(file) }.to output("Not an GRr project\n").to_stdout
      end
    end

    context 'when GRr project is initialized' do
      before do
        allow(Dir).to receive(:exist?).with(GRr::GRR_DIRECTORY).and_return(true)
      end

      it 'adds blob file' do
        expect(File).to receive(:open).with(blob_path, 'w').and_return('Add me!')
        allow(File).to receive(:open).with(GRr::INDEX_PATH, 'a')
        GRr::Command::Add.call(file)
      end

      it 'adds file to index' do
        file_spy = spy('File')
        allow(File).to receive(:open).with(blob_path, 'w').and_return('Add me!')
        allow(File).to receive(:open).with(GRr::INDEX_PATH, 'a').and_yield(file_spy)
        expect(file_spy).to receive(:puts).with('5b4c3b70ed776803408939a6652386a0b0506d43 spec/fixtures/add_file.rb')
        GRr::Command::Add.call(file)
      end
    end
  end
end
