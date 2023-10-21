# frozen_string_literal: true
# typed: strict

require 'nokogiri'
require 'uri'
require 'date'
require 'sorbet-runtime'

class ProgramPageScraper
  extend T::Sig

  sig { params(doc: Nokogiri::HTML::Document).returns(ScrapeResult) }
  def process(doc)
    result = ScrapeResult.new(
      id: doc.css('div.prog-preview').css('a').first['href'].split('=').last.to_i,
      title: doc.css('div.prog-preview').css('div.news-category-title').first.text,
      description: doc.css('div.prog-preview').css('div.prog-descr').first.text.strip,
      image: URI.join('https://ukr.radio', doc.css('div.prog-preview').css('img').first['src']),
      # (doc.css('div.prog-preview').css('img').first['src']),
      link: URI.join('https://ukr.radio', doc.css('div.prog-preview').css('a').first['href']),
      items: []
    )
    result.items += process_items(doc)
    result
  end

  sig { params(doc: Nokogiri::HTML::Document).returns(T::Array[PodcastItem]) }
  def process_items(doc)
    doc.css('div.program-item').map do |item|
      PodcastItem.from_css_item(item)
    end
  end
end

class PodcastItem < T::Struct
  extend T::Sig

  const :title, String
  const :link, URI
  const :description, String
  const :updated, Time

  sig { params(item: Nokogiri::XML::Element).returns(PodcastItem) }
  def self.from_css_item(item)
    control = item.css('div.program-item-controls').first.css('div')
    PodcastItem.new(
      title: item.css('div.program-item-content').css('div').css('p').first.text,
      link: URI.join('https://ukr.radio', control.first['data-media-path']),
      description: item.css('div.program-item-content').css('div').css('p').first.text,
      updated: DateTime.parse("#{control.first['data-media-date']} #{control.first['data-media-time']}").to_time
    )
  end
end

class ScrapeResult < T::Struct
  prop :id, Integer
  prop :title, String
  prop :link, URI
  prop :description, String
  prop :image, URI
  prop :items, T::Array[PodcastItem]
end
