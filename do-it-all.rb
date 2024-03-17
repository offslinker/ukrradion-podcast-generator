#!/usr/bin/env ruby
# typed: strict
# frozen_string_literal: true

require_relative 'lib/show_getter'
require_relative 'lib/program_processor'

shows = ShowGetter.new.list_of_shows.shuffle
puts "Found #{shows.size} shows"

Dir.mkdir('results')
index_html = '<html lang="ua"><head><title>Список подкастів</title></head><body><h1>Список подкастів</h1><ul>'
shows.each_with_index do |show_uri, i|
  show_id = show_uri.query.split('=').last
  puts "Processing #{show_uri} show #{i} out of #{shows.size} shows"
  if File.exist?("results/#{show_id}.rss")
    index_html += "<li><a href='#{show_id}.rss'>#{show_id}</a></li>"
    puts "Skipping #{show_id} because it already exists"
  else
    program_processor = ProgramProcessor.new(url: show_uri)
    result = program_processor.process

    File.write("results/#{show_id}.rss", result.to_rss)
    index_html += "<li><a href='#{show_id}.rss'>#{result.title}</a></li>"
    File.write('results/index.html', index_html)
  end
end
index_html += '</ul></body></html>'
File.write('results/index.html', index_html)
