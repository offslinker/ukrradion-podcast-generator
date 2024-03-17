# frozen_string_literal: true
# typed: strict

require 'net/http'
require 'nokogiri'
require_relative 'scrape_result'
require_relative 'program_page_scraper'

class ProgramProcessor < T::Struct
  extend T::Sig

  const :url, String
  const :id, T.nilable(String)

  sig { params(url: T.nilable(String), id: T.nilable(String)).void }
  def initialize(url: nil, id: nil)
    if id.nil?
      raise(ArgumentError, 'Either url or id must be provided') if url.nil?

      @url = url
    else
      @url = "https://ukr.radio/prog.html?id=#{id}"
    end
    super(url: @url, id: id)
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
  rescue Exception => e
    warn "Error: #{e.message}"
    warn e.backtrace
    warn "Error: #{uri(page_number)}"
    raise e
  end

  private

  sig { params(page_number: Integer).returns(URI) }
  def uri(page_number)
    URI("#{url}&page=#{page_number}")
  end

  sig { params(page_number: Integer).returns(Nokogiri::HTML::Document) }
  def read_page(page_number)
    page = Net::HTTP.get(uri(page_number))
    # File.write("spec/fixtures/tmp/prog#{T.must(page_number)}.html", page)
    Nokogiri::HTML(page)
  end

  sig { params(doc: Nokogiri::HTML::Document).returns(T::Boolean) }
  def next_page_exists?(doc)
    found_current = T.let(false, T::Boolean)
    current = doc.css('.btn-pagination').css('li.current').first
    doc.css('.btn-pagination').css('li').each do |li|
      return true if found_current

      found_current = li == current
    end
    false
  end
end
