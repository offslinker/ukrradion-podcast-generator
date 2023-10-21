# frozen_string_literal: true
# typed: false

require 'program_processor'

RSpec.describe ProgramProcessor do
  describe '#get_next_page_url' do
    context 'when there is a next page' do
      it 'returns the URL for the next page' do
        program_processor = described_class.new('https://ukr.radio/prog.html?id=604')
        next_page_url = program_processor.get_next_page_url

        expect(next_page_url).to eq('hhttps://ukr.radio/prog.html?id=604&page=2')
      end
    end

    context 'when there is no next page' do
      it 'returns nil' do
        program_processor = described_class.new('https://ukr.radio/prog.html?id=604')
        next_page_url = program_processor.get_next_page_url

        expect(next_page_url).to be_nil
      end
    end
  end
end
