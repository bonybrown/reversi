#!/bin/env ruby
require 'stringio'

def get_string(f)
  size = f.read(2).unpack("S<")[0]
  string = f.read(size-1)
  f.read(1)
  string
end

def get_bytes(file,length)
  file.read(length).unpack("C*")
end

def read_types_table(f)
  entries = f.read(2).unpack("S<")[0]
  puts "type entries: #{entries}"
  entries.times do |i|
    kind = f.read(2).unpack("S<")[0]
    if kind == 18
      name = get_string(f)
      print name
      pp get_bytes(f,2)
      next
    end
    size = f.read(2).unpack("S<")[0]
    print "\t ##{i} type=#{kind} size=#{size}"

    if kind == 17
      array_type = f.read(2).unpack("S<")[0]
      print " of type ##{array_type}"
    end
    puts
    if size > 0 && kind == 16
      size.times do 
        puts "\t\t ##{f.read(2).unpack("S<")[0]} #{get_string(f)}"
      end
    end
    tag_count = f.read(2).unpack("S<")[0]
    tag_count.times do
      tag = f.read(2).unpack("S<")[0]
      puts "\t\t tag: #{tag}"
    end
  end
end

def read_constants_table(f)
  entries = f.read(2).unpack("S<")[0]
  puts "constant entries: #{entries}"
  entries.times do 
    puts "\t#{get_bytes(f,1)} #{get_string(f)}"
  end
end

def read_globals_table(f)
  entries = f.read(2).unpack("S<")[0]
  puts "globals entries: #{entries}"
  entries.times do 
    puts "\t#{get_string(f)} #{get_bytes(f,4)} "
  end
end

def read_package_table(f)
  entries = f.read(2).unpack("S<")[0]
  puts "package entries: #{entries}"
  entries.times do 
    puts "\t#{get_string(f)}"
  end
end

def read_tag_table(f)
  entries = f.read(2).unpack("S<")[0]
  puts "tag entries: #{entries}"
  entries.times do 
    puts "\t#{get_string(f)} = #{get_string(f)}"
  end
end


def read_function_table(f)
  entries = f.read(2).unpack("S<")[0]
  puts "functions entries: #{entries}"
  entries.times do 
    puts "\t#{get_string(f)} #{get_bytes(f,4)} "
  end
end

def read_function_body(f)
  puts "FUNCTION: #{get_string(f)}"
  loop do
    type = f.read(1).unpack('C')[0]
    break if type == 6
    size = f.read(2).unpack('S<')[0]
    case type
    when 0
      puts "[0] PARAMETERS IN?? size = #{size}"
      pp get_bytes(f, 3)
    when 1
      puts "[1] ??? size = #{size}"
      pp get_bytes(f,size)
    when 2
      puts "[2] code size = #{size}"
      ops = get_bytes(f,size)
      ops.each do |code|
        printf("%02x ", code)
      end
      puts
    when 3
      puts "[3] locals size = #{size}"
      size.times do
        name = get_string(f)
        type_info = get_bytes(f,4)
        puts "\t#{name} #{type_info.inspect}"
      end
    when 4
      puts "[4] src map size = #{size}"
      size.times do 
        lineno = f.read(2).unpack("S<")[0]
        offset = f.read(2).unpack("S<")[0]
        puts "\tline=#{lineno}  offset=#{offset}"
      end
    when 5
      puts "[5] Exception table??? size = #{size}"
      size.times do 
        ip,cl,act,jmp = f.read(6).unpack("S<CCS<")
        puts "\t fromip=#{ip} cl=#{cl} act=#{act} jmpip=#{jmp}"
      end
    end
  end
end


File.open(ARGV[0], 'rb') do |f|
  four_js = f.read(4)
  raise StandardError, "Not a 4js file" if four_js != "JJJJ"
  pp get_bytes(f,3)
  loop do
    table = get_bytes(f,1)[0]
    puts "TABLE: #{table}"
    case table
    when 1 # module name
      puts module_name = get_string(f)
    when 6 # build version
      puts build = get_string(f)
    when 8 # source ref
      puts source = get_string(f)
    when 9 # package refs?
      read_package_table(f)
    when 10 # end
      read_tag_table(f)
      break
    end
  end
  loop do
    table = get_bytes(f,1)[0]
    puts "TABLE: #{table}"
    case table
    when 10
      read_package_table(f)
    when 1 # types
      read_types_table(f)
    when 0 # constants
      read_constants_table(f)
    when 2 # globals
      read_globals_table(f)
    when 3 # module vars
      read_globals_table(f)
    when 4 # function table
      read_function_table(f)
    when 5 #function
      read_function_body(f)
    when 11 #end
      break
    end
  end
  
end