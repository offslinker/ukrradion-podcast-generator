#!/usr/bin/env ruby
# typed: strict
# frozen_string_literal: true

require_relative 'lib/program_processor'
if ARGV.length != 1
  puts 'Usage: runner.rb <url>'
  exit 1
end
puts "Processing #{ARGV[0]}"
program_processor = ProgramProcessor.new(url: ARGV[0])
result = program_processor.process
result.to_rss
