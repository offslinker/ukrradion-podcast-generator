# frozen_string_literal: true
# typed: strict

require_relative 'podcast_item'
require 'rss'
require 'sorbet-runtime'

class ScrapeResult < T::Struct
  extend T::Sig

  prop :id, Integer
  prop :title, String
  prop :link, URI
  prop :description, String
  prop :image, URI
  prop :items, T::Array[PodcastItem]

  sig { returns(RSS::Rss) }
  def to_rss
    RSS::Maker.make('2.0') do |maker|
      maker.channel.title = title
      maker.channel.description = description
      maker.channel.link = link
      maker.channel.updated = Time.now.to_s

      items.each do |item|
        maker.items.new_item do |rss_item|
          rss_item.title = item.title
          rss_item.link = item.link
          rss_item.description = item.description
          rss_item.updated = item.updated.to_s
          rss_item.itunes_image = item.image.to_s
        end
      end
    end
  end
end
