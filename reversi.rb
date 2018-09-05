#!/usr/bin/env ruby
require_relative 'parser'
require 'optparse'

OUTPUT_FORMATS=[:human,:debug,:executable]

options = {}
optparse = OptionParser.new do|opts|
  opts.banner = "Usage: reversi.rb [options] fglrun-d.output"
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


parser = Parser.new(options[:output])

ARGF.each_line do |l|
  parser.parse(l)
end


def output_debug(parser)
  line_no = 1

  parser.lines.keys.sort.each do |n|
    if( line_no > n )
      puts "ERROR: LINE NUMBER OVERRUN"
      exit(1)
    end
    while line_no < (n-1)
      $stdout.puts 
      line_no += 1
    end

    parser.lines[n].each.with_index do |l,i|
      if i == 0 || l.match(/l_\d+:/)
        $stdout.puts
        label = ' ' * 16
        line_no +=1
        $stdout.write("#{n} ")
      end
      if l.match(/l_\d+:/)
        label = l.rjust(16)
        $stdout.write label
      else
        $stdout.write "#{label}#{l}; "
        label = ''
      end
    end
  end
end


def output_human(parser)

  parser.lines.keys.sort.each do |n|
    $stdout.write "#{n.to_s.rjust(5)} #{parser.labels[n].to_s.rjust(10)}"
    parser.lines[n].each.with_index do |l,i|
      $stdout.write( " " * 16 ) unless i == 0
      $stdout.puts l
    end
  end
end

case options[:output]
when :human
  output_human(parser)
when :debug
  output_debug(parser)
when :executable
  puts "Not implemented yet, sorry"
end
