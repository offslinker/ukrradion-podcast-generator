# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'

class PodcastItem < T::Struct
  extend T::Sig

  const :title, String
  const :link, URI
  const :description, String
  const :updated, Time

  sig { params(item: Nokogiri::XML::Element).returns(PodcastItem) }
  def self.from_css_item(item)
    control = item.css('div.program-item-controls').first.css('div')
    title_p = item.css('div.program-item-content').css('div').css('p').first
    title = if title_p.nil?
              item.css('div.program-item-content').css('div.socials').first.next_element.text
            else
              title_p.text
            end
    PodcastItem.new(
      title: title,
      link: URI.join('https://ukr.radio', control.first['data-media-path']),
      description: title,
      updated: DateTime.parse("#{control.first['data-media-date']} #{control.first['data-media-time']}").to_time
    )
  end
end
