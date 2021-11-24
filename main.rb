#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'net/http'

class RandomWords
  def initialize
    @parser = OptionParser.new
    @file = 'words.txt'
  end

  def parse
    define_options

    ARGV << '-h' if ARGV.empty?
    @parser.parse!
  end

  def define_options
    @parser.banner = "Usage: #{__FILE__} [options]"

    %w[file download get help].each { |option| send("define_#{option}_option") }
  end

  def define_file_option
    @parser.on('-f', '--filename FILENAME',
               'path to the file with which the program will operate') { |file| @file = file }
  end

  def define_download_option
    @parser.on('-d', '--download', 'download words and save them to the file') do
      uri = URI('https://petscan.wmflabs.org/?format=plain&psid=20679439')
      File.write(@file, Net::HTTP.get(uri))
    end
  end

  def define_get_option
    @parser.on('-g', '--get N', Integer, 'show N random words from the file') do |n|   
      raise ArgumentError, 'file does not exist' unless File.file?(@file)

      puts IO.readlines(@file).sample(n)
    end
  end

  def define_help_option
    @parser.on('-h', '--help', 'show this message') do
      puts @parser
      exit
    end
  end
end

RandomWords.new.parse