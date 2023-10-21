# frozen_string_literal: true
# typed: strict

require 'net/http'
require 'nokogiri'

class ProgramProcessor < T::Struct
  extend T::Sig

  const :page_number, Integer, default: 1
  const :url, String

  sig { params(url: String).void }
  def initialize(url)
    @page_number = 1
    @url = url
  end

  sig { returns(T::Boolean) }
  def public_next_page_exists?
    page = Net::HTTP.get(URI("#{url}&page=#{page_number}"))
    doc = Nokogiri::HTML(page)
    next_page_exists(doc)
  end

  private

  sig { params(doc: Nokogiri::HTML::Document).returns(T::Boolean) }
  def next_page_exists(doc)
    found_current = false
    current = doc.css('.btn-pagination').css('li.current').first
    doc.css('.btn-pagination').css('li').each do |li|
      return true if found_current

      found_current = li == current
    end
    false
  end
end
