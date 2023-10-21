# typed: false
# frozen_string_literal: true

require_relative '../lib/program_page_scraper'

RSpec.describe ProgramPageScraper do
  describe '#process' do
    it 'gets metadata' do
      scraper = described_class.new
      text = File.read('spec/fixtures/prog604.html')
      doc = Nokogiri::HTML(text)
      result = scraper.process(doc)
      expect(result.id).to eq(604)
      expect(result.title).to eq('Антологія. Український альбом')
      expect(result.link.to_s).to eq('https://ukr.radio/prog.html?id=604')
      expect(result.description).to eq('Історія становлення українського шоу-бізнесу у персоналіях.')
    end

    it 'gets podcast items' do
      scraper = described_class.new

      text = File.read('spec/fixtures/prog604.html')
      doc = Nokogiri::HTML(text)
      result = scraper.process(doc)
      expect(result.items.size).to eq(10)
      expect(result.items.first.title).to eq('Юркеш “Менуети” 2007')
      expect(result.items.first.link.to_s).to eq('https://ukr.radio/audio_slice/AIR-UR2/20211103/2979820.mp3')
      expect(result.items.first.description).to eq('Юркеш “Менуети” 2007')
      expected_date = Time.new(2021, 11, 3, 19, 4, 3)
      expect(result.items.first.updated).to eq(expected_date)
    end
  end
end
