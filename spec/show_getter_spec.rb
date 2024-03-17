# frozen_string_literal: true
# typed: false

require 'show_getter'
require 'webmock/rspec'

RSpec.describe ShowGetter do
  describe '#process' do
    it 'loads all pages' do
      body = File.read('spec/fixtures/progs.html')
      stub_request(:get, 'https://ukr.radio/progs.html?channelID=1')
        .to_return(status: 200, body: body)
      stub_request(:get, 'https://ukr.radio/progs.html?channelID=2')
        .to_return(status: 200, body: body)
      stub_request(:get, 'https://ukr.radio/progs.html?channelID=3')
        .to_return(status: 200, body: body)
      stub_request(:get, 'https://ukr.radio/progs.html?channelID=4')
        .to_return(status: 200, body: body)
      stub_request(:get, 'https://ukr.radio/progs.html?channelID=5')
        .to_return(status: 200, body: body)

      show_getter = described_class.new
      result = show_getter.get_list_of_shows
      expect(result.size).to eq(5 * 158)
    end
  end
end
