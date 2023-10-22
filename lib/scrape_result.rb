# frozen_string_literal: true
# typed: strict

require_relative 'podcast_item'

class ScrapeResult < T::Struct
  prop :id, Integer
  prop :title, String
  prop :link, URI
  prop :description, String
  prop :image, URI
  prop :items, T::Array[PodcastItem]
end
