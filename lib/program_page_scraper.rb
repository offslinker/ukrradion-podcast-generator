# frozen_string_literal: true
# typed: strict

require 'nokogiri'
require 'uri'
require 'date'
require 'sorbet-runtime'
require_relative 'podcast_item'
require_relative 'scrape_result'

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
