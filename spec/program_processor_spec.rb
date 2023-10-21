# frozen_string_literal: true
# typed: false

require 'program_processor'
require 'webmock/rspec'

RSpec.describe ProgramProcessor do
  describe '#process' do
    it 'loads all pages' do
      stub_request(:get, 'https://ukr.radio/prog.html?id=604&page=1')
        .to_return(status: 200, body: File.read('spec/fixtures/prog604.html'))
      stub_request(:get, 'https://ukr.radio/prog.html?id=604&page=2')
        .to_return(status: 200, body: File.read('spec/fixtures/prog604_last.html'))

      program_processor = described_class.new('https://ukr.radio/prog.html?id=604')
      result = program_processor.process
      expect(result.items.size).to eq(12)
    end
  end
end
