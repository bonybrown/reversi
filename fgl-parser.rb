#!/bin/env ruby
require "stringio"

class FglParser
  module FglCode
    class Constant < Struct.new(:value, :type_index); end
    class Annotation < Struct.new(:key, :value); end
    class Variable < Struct.new(:name, :type_index); end
    class TypeDef < Struct.new(:type_id, :index, :name, :size, :array_type, :structure, :annotations)
      def name
        case type_id
        when 0
          "##{index} String"
        when 2
          "##{index} Char[#{size - 1}]"
        when 7
          "##{index} Varchar[#{size - 1}]"
        when 9
          "##{index} SmallInt"
        when 10
          "##{index} Integer"
        when 11
          "##{index} Date"
        when 14
          "##{index} Decimal(#{size >> 8},#{ size & 255})"
        when 16
          "##{index} Struct"
        when 17
          "##{index} Array[#{size}]"
        else
          "##{index} TBD"
        end
      end
    end
    class File
      attr_reader :types, :functions, :constants, :annotations, :globals

      def initialize
        @types = []
        @functions = {}
        @constants = []
        @annotations = []
        @globals = []
      end

      def print_types
        @types.each do |t|
          case t.type_id
          when 16
            puts "#{t.name} OF \n\t#{t.structure.map{|s| s.name + ' ' + @types[s.type_index].name}.join("\n\t")}"
          when 17
            puts "#{t.name} OF #{@types[t.array_type].name}"
          else
            puts t.name
          end
        end
      end
    
    end
  end

  def initialize(filename)
    @filename = filename
  end

  def parse
    @code = FglCode::File.new
    File.open(@filename, "rb") do |f|
      @file = f
      four_js = f.read(4)
      raise StandardError, "Not a 4js file" if four_js != "JJJJ"
      pp read_bytes(3)
      loop do
        table = read_byte
        puts "TABLE: #{table}"
        case table
        when 1 # module name
          puts module_name = read_string
        when 6 # build version
          puts build = read_string
        when 8 # source ref
          puts source = read_string
        when 9 # package refs?
          read_package_table
        when 10 # end
          read_tag_table
          break
        end
      end
      loop do
        table = read_byte
        puts "TABLE: #{table}"
        case table
        when 0 # constants
          read_constants_table
        when 1 # types
          read_types_table
        when 2 # globals
          read_globals_table
        when 3 # module vars
          read_globals_table
        when 4 # function table
          read_function_table
        when 5 #function
          read_function_body
        when 11 #end
          break
        end
      end
    end
    @code
  end

  def read_string
    size = read_word
    string = @file.read(size - 1)
    @file.read(1)
    string
  end

  def read_bytes(length)
    @file.read(length).unpack("C*")
  end

  def read_byte
    @file.read(1).unpack("C")[0]
  end

  def read_word
    @file.read(2).unpack("S<")[0]
  end

  def read_types_table
    entries = read_word
    puts "type entries: #{entries}"
    entries.times do |i|
      name = ''
      kind = read_word
      type_def = FglCode::TypeDef.new(kind, i)
      if kind == 18
        name = read_string
        type_def.name = name
        pp read_bytes(2)
        next
      end

      size = read_word
      type_def.size = size

      if kind == 17
        array_type = read_word
        type_def.array_type = array_type
      end

      if size > 0 && kind == 16
        structure = []
        size.times do
          sub_kind = read_word
          sub_name = read_string
          structure << FglCode::Variable.new(sub_name, sub_kind)
        end
        type_def.structure = structure
      end
      tag_count = read_word
      annotations = []
      tag_count.times do
        annotations << read_word
      end
      type_def.annotations = annotations
      @code.types << type_def
    end
  end

  def read_constants_table
    entries = read_word
    entries.times do
      type_index = read_byte
      value = read_string
      @code.constants << FglCode::Constant.new(value, type_index)
    end
  end

  def read_globals_table
    entries = read_word
    entries.times do
      name = read_string
      type_index = read_word
      unknown = read_word
      @code.globals << FglCode::Variable.new(name, type_index)
    end
  end

  def read_package_table
    entries = read_word
    puts "package entries: #{entries}"
    entries.times do
      puts "\t#{read_string}"
    end
  end

  def read_tag_table
    entries = read_word
    entries.times do
      key = read_string
      value = read_string
      @code.annotations << FglCode::Annotation.new(key, value)
    end
  end

  def read_function_table
    entries = read_word
    puts "functions entries: #{entries}"
    entries.times do
      puts "\t#{read_string} #{read_bytes(4)} "
    end
  end

  def read_function_body
    puts "FUNCTION: #{read_string}"
    loop do
      type = read_byte
      break if type == 6
      size = read_word
      case type
      when 0
        puts "[0] PARAMETERS IN?? size = #{size}"
        pp read_bytes(3)
      when 1
        puts "[1] ??? size = #{size}"
        pp read_bytes(size)
      when 2
        puts "[2] code size = #{size}"
        ops = read_bytes(size)
        ops.each do |code|
          printf("%02x ", code)
        end
        puts
      when 3
        puts "[3] locals size = #{size}"
        size.times do
          name = read_string
          type_info = read_bytes(4)
          puts "\t#{name} #{type_info.inspect}"
        end
      when 4
        puts "[4] src map size = #{size}"
        size.times do
          lineno = read_word
          offset = read_word
          puts "\tline=#{lineno}  offset=#{offset}"
        end
      when 5
        puts "[5] Exception table size = #{size}"
        size.times do
          ip, cl, act, jmp = @file.read(6).unpack("S<CCS<")
          puts "\t fromip=#{ip} cl=#{cl} act=#{act} jmpip=#{jmp}"
        end
      end
    end
  end
end

x = FglParser.new(ARGV[0]).parse
pp x
x.print_types
