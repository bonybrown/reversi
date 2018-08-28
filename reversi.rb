#!/usr/bin/env ruby
require_relative 'parser'

parser = Parser.new

ARGF.each_line do |l|
  parser.parse(l)
end

parser.lines.keys.sort.each do |n|
  $stdout.write "#{n.to_s.rjust(5)} #{parser.labels[n].to_s.rjust(10)}"
  parser.lines[n].each.with_index do |l,i|
    $stdout.write( " " * 16 ) unless i == 0
    $stdout.puts l
  end
end

#p parser.types
#p parser.variable_types
