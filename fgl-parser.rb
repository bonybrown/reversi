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
        when 4
          "##{index} DateTime(#{size >> 8},#{ size & 255})"
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
          "##{index} TBD type id=#{type_id} (#{size >> 8},#{ size & 255})"
        end
      end
    end
    class Function < Struct.new(:name, :arg_count, :return_count, :locals, :code, :source_map, :exception_table); end
    class File
      attr_reader :types, :functions, :constants, :annotations, :globals, :module_vars, :packages
      attr_accessor :module_name, :build, :source

      def initialize
        @types = []
        @functions = {}
        @constants = []
        @annotations = []
        @globals = []
        @module_vars = []
        @packages = []
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
      raise NotImplementedError, "Unexpected bytes after JJJJ header" if read_bytes(3) != [0,16,0]
      loop do
        table = read_byte
        case table
        when 1 # module name
          @code.module_name = read_string
        when 6 # build version
          @code.build = read_string
        when 8 # source ref
          @code.source = read_string
        when 9 # package refs?
          read_package_table
        when 10 # end
          read_tag_table
          break
        else
          raise NotImplementedError, "Unexpected table type #{table} at offset #{@file.pos} of #{@filename}"
        end
      end
      loop do
        table = read_byte
        case table
        when 0 # constants
          read_constants_table
        when 1 # types
          read_types_table
        when 2 # globals
          read_globals_table
        when 3 # module vars
          read_module_var_table
        when 4 # function table
          read_function_table
        when 5 #function
          read_function_body
        when 11 #end
          break
        else
          raise NotImplementedError, "Unexpected table type #{table} at offset #{@file.pos} of #{@filename}"
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
    entries.times do |i|
      name = ''
      kind = read_word
      type_def = FglCode::TypeDef.new(kind, i)
      if kind == 18
        name = read_string
        type_def.name = name
        unknown = read_word
        raise NotImplementedError, "Unexpected word #{unknown} on type 18 offset #{@file.pos} of #{@filename}" if unknown != 0
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

  def read_module_var_table
    entries = read_word
    entries.times do
      name = read_string
      type_index = read_word
      unknown = read_word
      @code.module_vars << FglCode::Variable.new(name, type_index)
    end
  end

  def read_package_table
    entries = read_word
    entries.times do
      @code.packages << read_string
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
    entries.times do
      name = read_string
      arg_count = read_word
      return_count = read_word
      @code.functions[name] = FglCode::Function.new(name, arg_count, return_count)
    end
  end

  def read_function_body
    name = read_string
    function_def = @code.functions.fetch(name) do
      @code.functions[name] = FglCode::Function.new(name)
    end
    loop do
      type = read_byte
      break if type == 6
      case type
      when 0
        arg_count = read_word
        unknown = read_byte
        return_count = read_word
        raise NotImplementedError, 'expected unknown byte to eq 1' if unknown != 1
        function_def.arg_count = arg_count
        function_def.return_count = return_count
      when 1
        raise NotImplementedError, "expected table type 1 in read_function_body at offset #{@file.pos} of #{@filename}"
      when 2
        size = read_word
        ops = read_bytes(size)
        function_def.code = ops
        puts
      when 3
        size = read_word
        function_def.locals = []
        size.times do
          name = read_string
          type_index = read_word
          unknown = read_word
          function_def.locals << FglCode::Variable.new(name, type_index)
        end
      when 4
        size = read_word
        function_def.source_map = []
        size.times do
          lineno = read_word
          offset = read_word
          function_def.source_map << {ip: offset, line: lineno}
        end
      when 5
        size = read_word
        function_def.exception_table = []
        size.times do
          ip, cl, act, jmp = @file.read(6).unpack("S<CCS<")
          function_def.exception_table << {ip: ip, cl: cl, act: act, jmp: jmp}
        end
      end
    end
  end
end

x = FglParser.new(ARGV[0]).parse
#pp x
x.print_types
