#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'net/http'

class RandomWords
  def initialize
    @filename = 'words.txt'
  end

  def parse
    OptionParser.new do |opts|
      opts.on('-f', '--filename FILENAME') { |n| @filename = n }
      opts.on('-d', '--download') { download }
      opts.on('-g', '--get N') { |n| get(n.to_i) }
    end.parse!
  end

  def download
    uri = URI('https://petscan.wmflabs.org/?format=plain&psid=20679439')
    File.write(@filename, Net::HTTP.get(uri))
  end

  def get(n)
    puts IO.readlines(@filename).sample(n)
  end
end

RandomWords.new.parse
