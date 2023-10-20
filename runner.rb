# frozen_string_literal: true

require 'rss'

rss = RSS::Maker.make('2.0') do |maker|
  maker.channel.title = 'My Podcast'
  maker.channel.description = 'A podcast about Ruby programming'
  maker.channel.link = 'http://example.com/podcast'
  maker.channel.updated = Time.now.to_s

  maker.items.new_item do |item|
    item.title = 'Episode 1'
    item.link = 'http://example.com/podcast/1'
    item.description = 'The first episode of our podcast'
    item.updated = Time.now.to_s
  end
end

binding.irb
puts rss
