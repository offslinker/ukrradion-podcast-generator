# frozen_string_literal: true

# FILEPATH: /path/to/scrape_result_spec.rb

require 'rspec'
require_relative '../lib/scrape_result'
require_relative '../lib/podcast_item'

RSpec.describe ScrapeResult do
  describe '#to_rss' do
    subject(:rss) do
      described_class.new(id: 10, title: title, description: description, link: link, items: items, image: image).to_rss
    end

    let(:title) { 'Test Title' }
    let(:description) { 'Test Description' }
    let(:link) { URI('https://example.com') }
    let(:image) { URI('https://example.com/image.jpg') }
    let(:first_item_updated) { Time.new(2020, 1, 1) }
    let(:last_item_updated) { Time.new(2020, 1, 2) }
    let(:items) do
      [
        PodcastItem.new(
          title: 'Item 1',
          link: URI('https://example.com/item1'),
          description: 'Item 1 Description',
          updated: first_item_updated,
          image: URI('https://example.com/item1.jpg')
        ),
        PodcastItem.new(
          title: 'Item 2',
          link: URI('https://example.com/item2'),
          description: 'Item 2 Description',
          updated: last_item_updated,
          image: URI('https://example.com/item2.jpg')
        )
      ]
    end

    it 'returns an RSS::Rss object with the correct attributes' do
      expect(rss).to be_a(RSS::Rss)
      expect(rss.channel.title).to eq(title)
      expect(rss.channel.description).to eq(description)
      expect(rss.channel.link).to eq(link)

      rss_items = rss.items
      expect(rss_items.size).to eq(items.size)

      items.each_with_index do |item, index|
        rss_item = rss_items[index]
        expect(rss_item.title).to eq(item.title)
        expect(rss_item.link).to eq(item.link)
        expect(rss_item.description).to eq(item.description)
        expect(rss_item.pubDate).to eq(item.updated)
        expect(rss_item.itunes_image.href).to eq(item.image.to_s)
      end
    end
  end
end
