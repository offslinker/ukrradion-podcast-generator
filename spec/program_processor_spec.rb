# frozen_string_literal: true
# typed: false

require 'program_processor'
require 'webmock/rspec'

RSpec.describe ProgramProcessor do
  describe '#next_page_exists?' do
    context 'when there is a next page' do
      it 'returns the URL for the next page' do
        stub_request(:get, 'https://ukr.radio/prog.html?id=604&page=1')
          .to_return(status: 200, body: File.read('spec/fixtures/prog604.html'))

        program_processor = described_class.new('https://ukr.radio/prog.html?id=604')
        expect(program_processor.public_next_page_exists?).to be true
      end
    end

    context 'when there is no next page' do
      it 'returns nil' do
        # Mock HTTP request to return fixture
        stub_request(:get, 'https://ukr.radio/prog.html?id=604&page=1')
          .to_return(status: 200, body: File.read('spec/fixtures/prog604_last.html'))

        program_processor = described_class.new('https://ukr.radio/prog.html?id=604')
        expect(program_processor.public_next_page_exists?).to be false
      end
    end
  end
end
