# frozen_string_literal: true
# typed: false

require 'show_getter'
require 'webmock/rspec'

RSpec.describe ShowGetter do
  describe '#process' do
    it 'loads all pages' do
      stub_request(:get, 'https://ukr.radio/progs.html?channelID=1')
        .to_return(status: 200, body: File.read('spec/fixtures/prog604.html'))
      stub_request(:get, 'https://ukr.radio/progs.html?channelID=2')
        .to_return(status: 200, body: File.read('spec/fixtures/page2.html'))
      stub_request(:get, 'https://ukr.radio/progs.html?channelID=3')
        .to_return(status: 200, body: File.read('spec/fixtures/prog604_last.html'))

      program_processor = described_class.new(url: 'https://ukr.radio/prog.html?id=604')
      result = program_processor.process
      expect(result.items.size).to eq(22)
    end
  end
end
