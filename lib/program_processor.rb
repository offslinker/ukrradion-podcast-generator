# frozen_string_literal: true
# typed: strict

require 'net/http'
require 'nokogiri'
require_relative 'scrape_result'

class ProgramProcessor < T::Struct
  extend T::Sig

  const :url, String

  sig { params(url: String).void }
  def initialize(url)
    @page_number = 1
    @url = url
  end

  sig { returns(ScrapeResult) }
  def process
    page_number = 1
    page = read_page(page_number)
    result = ProgramPageScraper.new.process(page)

    while next_page_exists?(page)
      page_number += 1
      page = read_page(page_number)
      result.items += ProgramPageScraper.new.process(page).items
    end
    result
  end

  private

  sig { params(page_number: Integer).returns(Nokogiri::HTML::Document) }
  def read_page(page_number)
    page = Net::HTTP.get(URI("#{url}&page=#{page_number}"))
    Nokogiri::HTML(page)
  end

  sig { params(doc: Nokogiri::HTML::Document).returns(T::Boolean) }
  def next_page_exists?(doc)
    found_current = false
    current = doc.css('.btn-pagination').css('li.current').first
    doc.css('.btn-pagination').css('li').each do |li|
      return true if found_current

      found_current = li == current
    end
    false
  end
end
