#!/usr/bin/env ruby
require_relative 'fgl-parser'
require_relative 'fgl-engine'
require 'optparse'

OUTPUT_FORMATS=[:human,:debug,:executable]

options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "Usage: reversi.rb [options] any.42m"
  # Define the options, and what they do
  options[:output] = :human
  opts.on( '-o', '--output TYPE', 'Output format: human|debug|executable. Default human' ) do |type|
    options[:output] = type.to_sym
  end
  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!

if ! OUTPUT_FORMATS.include?(options[:output])
  $stderr.puts "#{options[:output]} is not a valid output option"
  $stderr.puts optparse.help
  exit(1)
end

parser = FglParser.new(ARGV[0])
model = parser.parse
engine = FglEngine.new(model)
engine.decode(ARGV[1])
