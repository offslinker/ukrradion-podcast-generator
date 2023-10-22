#!/usr/bin/env ruby
# typed: strict
# frozen_string_literal: true

require_relative 'lib/program_processor'

program_processor = ProgramProcessor.new(url: ARGV[0])
result = program_processor.process
puts result.to_rss
