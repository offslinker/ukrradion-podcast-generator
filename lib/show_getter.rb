# frozen_string_literal: true
# typed: strict
require 'nokogiri'
require 'net/http'

class ShowGetter
  extend T::Sig

  sig { returns(T::Array[URI]) }
  def get_list_of_shows
    (1..5).flat_map { |channel_id| get_shows_from_channel(channel_id) }
  end

  sig { params(channel_id: Integer).returns(T::Array[URI]) }
  def get_shows_from_channel(channel_id)
    page = Net::HTTP.get(uri(channel_id))
    html = Nokogiri::HTML(page)
    get_list_of_shows_from_html(html)
  end

  private

  sig { params(channel_id: Integer).returns(URI) }
  def uri(channel_id)
    URI("https://ukr.radio/progs.html?channelID=#{channel_id}")
  end

  sig { params(html: Nokogiri::HTML::Document).returns(T::Array[URI]) }
  def get_list_of_shows_from_html(html)
    html.css('a.flex-list-item').map do |show|
      URI.join("https://ukr.radio/", show.attributes['href'])
    end
  end
end
