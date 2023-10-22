# frozen_string_literal: true
# typed: strict

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
