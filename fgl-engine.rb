class FglEngine
  OPCODES = {
    0x00 => { name: :vm_noOp, argc: 0 },
    0x01 => { name: :vm_pushLoc, argc: 1 },
    0x02 => { name: :vm_pushLoc, argc: 2 },
    0x03 => { name: :vm_pushMod, argc: 1 },
    0x04 => { name: :vm_pushMod, argc: 2 },
    0x05 => { name: :vm_pushGlb, argc: 1 },
    0x06 => { name: :vm_pushGlb, argc: 2 },
    0x07 => { name: :vm_pushCon, argc: 1 },
    0x08 => { name: :vm_pushCon, argc: 2 },
    0x09 => { name: :vm_pushInt, argc: 2 },
    0x0a => { name: :vm_pushNull, argc: 0 },
    0x0b => { name: :vm_popArg, argc: 2 },
    0x0c => { name: :vm_thru, argc: 7 },
    0x0d => { name: :vm_genList, argc: 1 },
    0x0e => { name: :vm_genList, argc: 2 },
    0x0f => { name: :vm_assF, argc: 0 },
    0x10 => { name: :vm_assR, argc: 0 },
    0x11 => { name: :vm_load, argc: 1 },
    0x12 => { name: :vm_load, argc: 2 },
    0x13 => { name: :vm_call0, argc: 1 },
    0x14 => { name: :vm_call0, argc: 2 },
    0x15 => { name: :vm_call1, argc: 1 },
    0x16 => { name: :vm_call1, argc: 2 },
    0x17 => { name: :vm_callN, argc: 1 },
    0x18 => { name: :vm_callN, argc: 2 },
    0x19 => { name: :vm_callRep, argc: 4 },
    0x1a => { name: :vm_oper, argc: 1 },
    0x1b => { name: :vm_retAll, argc: 1 },
    0x1c => { name: :vm_retAll, argc: 2 },
    0x1d => { name: :vm_ret, argc: 0 },
    0x1e => { name: :vm_goto, argc: 1 },
    0x1f => { name: :vm_goto, argc: 2 },
    0x20 => { name: :vm_jnz, argc: 1 },
    0x21 => { name: :vm_jnz, argc: 2 },
    0x22 => { name: :vm_jpz, argc: 1 },
    0x23 => { name: :vm_jpz, argc: 2 },
    0x24 => { name: :vm_jnc, argc: 1 },
    0x25 => { name: :vm_jnc, argc: 2 },
    0x26 => { name: :vm_jpc, argc: 1 },
    0x27 => { name: :vm_jpc, argc: 2 },
    0x28 => { name: :vm_jpe, argc: 4 },
    0x29 => { name: :vm_extend, argc: 0 },
    0x2a => { name: :vm_member, argc: 1 },
    0x2b => { name: :vm_member, argc: 2 },
    0x2c => { name: :vm_arrSub, argc: 0 },
    0x2d => { name: :vm_strSub, argc: 0 },
    0x2e => { name: :vm_strSub2, argc: 0 },
    0x2f => { name: :vm_strSubL, argc: 0 },
    0x30 => { name: :vm_strSubL2, argc: 0 },
    0x31 => { name: :vm_repSetOp, argc: 0 },
    0x32 => { name: :vm_goto, argc: 3 },
    0x33 => { name: :vm_jnz, argc: 3 },
    0x34 => { name: :vm_jpz, argc: 3 },
    0x35 => { name: :vm_jnc, argc: 3 },
    0x36 => { name: :vm_jpc, argc: 3 },
    0x37 => { name: :vm_jpe, argc: 5 },
    0x38 => { name: :vm_callNative, argc: 4 },
    0x39 => { name: :vm_breakpoint, argc: 0 },
  }

  class Stack
    def initialize
      @s = []
    end
  end

  def initialize(parsed_file_model)
    @file = parsed_file_model
    @context_stack = []
    @ip = 0
    @current_ip = nil
    @case_statement_start_ip = -1
  end

  def push(d, type = nil)
    if type.nil? && d.respond_to?(:type_index)
      type = @file.types[d.type_index]
    end
    context = {ip: @current_ip, line: @current_line, data: d, type: type}
    @context_stack.push(context)
  end
  
  def pop(n=nil)
    if n.nil?
      context = @context_stack.pop
      context[:data]
    else
      contexts = @context_stack.pop(n)
      contexts.map{|c| c[:data]}
    end
  end

  def pop_context(n=nil)
    if n.nil?
      context = @context_stack.pop
    else
      contexts = @context_stack.pop(n)
    end
  end

  def contexts
    @context_stack.pop(100)
  end

  def decode(function_name)
    functions = []
    if function_name
      functions << @file.functions[function_name]
    else
      functions = @file.functions.values.select{|f| f.code && !f.code.empty? }
    end
    
    raise "Function name #{function_name} not found" if functions.empty?

    display_code_header
    functions.each do |f|
      decode_function(f)
      display_code(f)
    end
  end

  def decode_function(function)
    @function = function
    @ip = 0
    @context_stack = []
    @result = []
    @labels = []
    code = @function.code
    lines = @function.source_map
    @current_line = nil
    @indent = 0
    @current_ip = nil
    while true do
      instruction = code[@ip]
      @current_line = lines[@ip] || @current_line
      @current_ip = @ip
      break if instruction.nil?
      #puts "current_line=#{@current_line} #{ '%02x' % instruction} #{OPCODES.dig(instruction, :name)}"
      argc = OPCODES.dig(instruction, :argc)
      args = nil
      @ip += 1
      if argc > 0
        args = code.slice(@ip,argc)
        @ip += argc
      end
      instruction_name = OPCODES.dig(instruction, :name)
      if instruction_name == :vm_jpe
        if @case_statement_start_ip == -1
          @case_statement_start_ip = @current_ip
        end
      else
        @case_statement_start_ip = -1
      end

      result = send(instruction_name, args)
      # HEAVY DEBUG
      # puts
      # puts "At IP=#{@ip} line=#{@current_line}, stack is:"
      # @context_stack.map{|x| [x[:data], x[:type]]}.each{|i| puts "\t #{i}" }
      if result == :statement
        context = @context_stack.pop
        #puts "STATEMENT #{context}"
        #pp @context_stack
        @result[context[:ip]] = context unless context.nil?
      end
      # if lines[@ip] 
      #   if @current_line != lines[@ip] 
      #       @indent -=1 if result == :indent_down
      #       contexts.each do |c|
      #         c[:indent] = @indent
      #         @result[c[:ip]] = c
      #       end
      #       @indent +=1 if result == :indent_up
      #   end
      # end
    end
  end

  def declare_variable(g, indent = '')
    type = @file.types[g.type_index]
    if type.nil?
      raise ArgumentError, "What is #{g.inspect}" 
    end
    return if g.member_of
    if type.structure
      members = type.structure.map{|m| ":#{m.name}" }
      puts "#{indent}#{g} = #{type.class_name}.new"
    elsif type.array_type
      puts "#{indent}#{g} = Array.new(#{type.size},nil)"
    else
      puts "#{indent}#{g} = nil # #{type.name}"
    end
  end

  def declare_types
    @file.types.each do |type|
      if type.structure
        members = type.structure.map{|m| ":#{m.name}" }
        puts "class #{type.class_name} < Struct.new(#{members.join(', ')}) ; end"
      end
    end
  end

  def display_code_header
    puts "require 'goto'"
    declare_types
    puts "# GLOBALS"
    @file.globals.each do |g|
      declare_variable(g)
    end
    puts "# MODULE VARIABLES"
    @file.module_vars.each do |g|
      declare_variable(g)
    end
  end

  def display_code(function)
    
    
    function.arg_list ||= []
    puts "\n# FUNCTION"
    puts "# #{@function.name}#{@function.signature}"
    puts "def #{@function.name}(#{function.arg_list.reverse.join(', ')})"
    function.locals.each do |l|
      unless function.arg_list.include?(l.name)
        declare_variable(l,"\t")
      end
    end
    
    puts "\tframe_start"
    code = function.code
    in_label = false
    @labels[0] = "start"
    code.count.times do |i|
      if @labels[i]
        puts "\tend" if in_label
        puts "\tlabel(:#{@labels[i]}) do"
        in_label = true
      end
      c = @result[i]
      if c
        print "#\tline #{c[:line]} (ip:#{c[:ip]})"
        print "\n"
        c[:data].each_line do |l|
          print "\t\t"
          print l.chomp
          print "\n"
        end
      end
    end
    puts "\tend" if in_label
    puts "\tframe_end"
    puts "end"
  end

  def args_to_index(args)
    shift = 0
    result = 0
    args.count.times do |i|
      result += (args[i] << shift)
      shift += 8
    end
    result
  end

  # signed integers
  def args_to_signed(args)
    v = args_to_index(args)
    case args.length
    when 1
      return v if v < 128
      return -(~v & 0xff ) -1
    when 2
      return v if v < 32768
      return -(~v & 0xffff ) -1
    end
  end
    
  def vm_noOp
  end

  def vm_assF(args)
    rhs = pop_context
    lhs = pop_context
    rhs_type = rhs[:type]
    lhs_type = lhs[:type]
    rhs = rhs[:data]
    lhs = lhs[:data]
    expression = "#{lhs} = #{lhs_type.assignment_expression(rhs, rhs_type)}"
    push expression, lhs_type
    :statement
  end

  def vm_assR(args)
    rhs = pop
    lhs = pop
    push "#{rhs} = #{lhs} # assR ??"
    :statement
  end

  def vm_pushCon(args)
    i = args_to_index(args)
    push @file.constants[i]
  end

  def vm_pushGlb(args)
    i = args_to_index(args)
    global = @file.globals[i]
    raise ArgumentError, "Did not find Global #{i} at ip=#{@current_ip}" if global.nil?
    push global
  end

  def vm_pushLoc(args)
    i = args_to_index(args)
    local = @function.locals[i]
    if local.nil?
      raise ArgumentError, "Did not find Local #{i} at ip=#{@current_ip}." 
    end
    push local
  end

  def vm_pushMod(args)
    i = args_to_index(args)
    module_var =  @file.module_vars[i]
    if module_var.nil?
      raise ArgumentError, "Did not find Module Variable #{i} at ip=#{@current_ip}." 
    end
    push module_var
  end

  def vm_pushNull(args)
    push 'nil', nil
  end

  def vm_call0(args)
    function_index = args_to_index(args)
    function = @file.functions.values[function_index]
    name = function.name
    call_args = pop(function.arg_count)
    case name
    when 'rts_doCat'
      dest = call_args[0].to_s
      src_ary = call_args[1].map{|a| a.to_s}.join(', ')
      push "#{dest} = [#{src_ary}].join"
      :statement
    when 'rts_forInit'
      #push "#{name}(#{call_args.join(', ')})"
      i = call_args[0]
      s = call_args[1]
      e = call_args[3]
      push "(#{i} = #{s}; #{e} - #{i})"
      :indent_up
    when 'rts_OpPop'
      statement = "# rts_OpPop(1) called, stack size=#{@context_stack.count}"
      @context_stack.pop
      push statement
      :statement
    when 'rts_initNull'
      call_args[0] = Array(call_args[0])
      statement = call_args[0].map{|a| "#{a} = nil"}.join("\n")
      push statement, nil
      :statement
    else
      push "#{name}(#{call_args.join(', ')})"
      :statement
    end
  end

  def vm_call1(args)
    vm_callN(args)
  end

  def vm_callN(args)
    empty_array_arg = false
    function_index = args_to_index(args)
    function = @file.functions.values[function_index]
    name = function.name
    if function.arg_count == 1
      call_args = pop
    else
      call_args = pop(function.arg_count)
    end
    if call_args.is_a?(Array)
      empty_array_arg = call_args.empty?
      call_args = call_args.map{|a| a.to_s }.join(', ')
    end
    if name == 'rts_sql_intovars'
      if empty_array_arg
        expression = 'nil'
      else
        expression = "lambda{|d|#{call_args} = d}"
      end
    else
      expression = "#{name}(#{call_args})"
    end
    push expression
  end

  # loads returned values from a function into variables
  def vm_load(args)
    count = args_to_index(args)
    dest = pop(count).map{|a| a.to_s}.join(', ')
    source = pop
    push "#{dest} = #{source}"
    :statement
  end


  def vm_strSub(args)
    subscript = pop
    string = pop_context
    expression = "#{string[:data]}[#{subscript} - 1]"
    push expression, string[:type]
  end

  # I _think_ strSubL is used when the string sub is the LHS of
  # an assignment? In ruby, it works, so just call strSub
  def vm_strSubL(args)
    vm_strSub(args)
  end
  def vm_strSubL2(args)
    vm_strSub2(args)
  end

  def vm_strSub2(args)
    end_s = pop
    if end_s.is_a?(FglParser::FglCode::Constant)
      end_s = end_s.to_s.to_i - 1
    else
      end_s = "#{end_s} -1"
    end
    start_s = pop
    if start_s.is_a?(FglParser::FglCode::Constant)
      start_s = start_s.to_s.to_i - 1
    else
      start_s = "#{start_s} -1"
    end
    string = pop_context
    expression = "#{string[:data]}[#{start_s}..#{end_s}]"
    push expression, string[:type]
  end

  def vm_arrSub(args)
    subscript = pop
    array = pop_context
    type = array[:type]
    raise ArgumentError, "Type (#{type}) is not an array at line #{@current_line}, function #{@function.name}" unless type.respond_to?(:array_type) && type.array_type
    expression = "#{array[:data]}[#{subscript}]"
    push expression, @file.types[type.array_type]
  end

  def vm_member(args)
    member_index = args_to_index(args)
    structure = pop_context
    type = structure[:type]
    expression = structure[:data]
    raise ArgumentError, "Expression #{expression} of type (#{type}) is not a structure at line #{@current_line}" unless type.structure
    member = type.structure[member_index]
    raise ArgumentError, "Expression #{expression} of type (#{type}) has no member at index (#{member_index}) at line #{@current_line}" unless member
    
    expression = "#{expression}.#{member.name}"
    member_type = @file.types[member.type_index]
    push expression, member_type
  end

  def vm_extend(args)
    structure = pop_context
    type = structure[:type]
    raise ArgumentError unless type.structure
    type.structure.each do |member|
      member_type = @file.types[member.type_index]
      push "#{structure[:data]}.#{member.name}", member_type
    end
  end

  def vm_oper(args)
    i = args_to_index(args)
    case i
    when 0 #rts_Op1Clipp
      rhs = pop
      expression = "#{rhs}.to_s.strip"
      push expression
    when 1 #rts_Op1Column
      rhs = pop
      expression = "Reporting.at_column(#{rhs})"
      push expression
    when 2 #rts_Op1IsNotNull
      rhs = pop
      expression = "!#{rhs}.nil?"
      push expression
    when 3 # rts_Op1IsNull
      rhs = pop
      expression = "#{rhs}.nil?"
      push expression
    when 4 #rts_Op1Not
      rhs = pop
      expression = "!#{rhs}"
      push expression
    when 5 # rts_Op1Spaces
      rhs = pop
      expression = "(' ' * #{rhs})"
      push expression
    when 6 # rts_Op1UMi
      rhs = pop
      expression = "-#{rhs}"
      push expression
    when 7 #rts_Op2And
      rhs = pop
      lhs = pop
      expression = "(#{lhs} && #{rhs})"
      push expression
    when 8 #rts_Op2Di
      rhs = pop
      lhs = pop
      expression = "(#{lhs} / #{rhs})"
      push expression
    when 9 #rts_Op2Eq
      rhs = pop
      lhs = pop
      expression = "(#{lhs} == #{rhs})"
      push expression
    when 10 #rts_Op2Ge
      rhs = pop
      lhs = pop
      expression = "(#{lhs} >= #{rhs})"
      push expression
    when 11 #rts_Op2Gt
      rhs = pop
      lhs = pop
      expression = "(#{lhs} > #{rhs})"
      push expression
    when 13 #rts_Op2IntMi
      rhs = pop
      lhs = pop
      expression = "#{lhs} - #{rhs}"
      push expression
    when 14 # rts_Op2IntMu
      rhs = pop
      lhs = pop
      expression = "(#{lhs} * #{rhs}).to_i"
      push expression
    when 15 # rts_Op2IntPl
      rhs = pop
      lhs = pop
      expression = "(#{lhs} + #{rhs})"
      push expression
    when 16 #rts_Op2Le
      rhs = pop
      lhs = pop
      expression = "(#{lhs} <= #{rhs})"
      push expression
    when 17 #rts_Op2Lt
      rhs = pop
      lhs = pop
      expression = "(#{lhs} < #{rhs})"
      push expression
    when 18 #rts_Op2Mi
      rhs = pop
      lhs = pop
      expression = "#{lhs} - #{rhs}"
      push expression
    when 19 #rts_Op2Mo
      rhs = pop
      lhs = pop
      expression = "#{lhs} % #{rhs}"
      push expression
    when 20 #rts_Op2Mu
      rhs = pop
      lhs = pop
      expression = "(#{lhs} * #{rhs})"
      push expression
    when 21 #rts_Op2Ne
      rhs = pop
      lhs = pop
      expression = "(#{lhs} != #{rhs})"
      push expression
    when 22 #rts_Op2Or
      rhs = pop
      lhs = pop
      expression = "(#{lhs} || #{rhs})"
      push expression
    when 23 # rts_Op2Pl
      rhs = pop
      lhs = pop
      expression = "(#{lhs} + #{rhs})"
      push expression
    when 25 # rts_Op2Test - SOMETHING ABOUT THIS IS NOT RIGHT
      rhs = pop
      lhs = pop
      push lhs
      expression = "(#{lhs} == #{rhs})"
      push expression
    # rts_Op2Using was removed from FGL 3, operations after this were re-numbered down
    # when 26 # rts_Op2Using
    #   format = pop
    #   data = pop
    #   expression = "(format_using(#{format},#{data}))"
    #   push expression
    when 26 #rts_OpFor
      loop_end = pop
      loop_index = pop
      expression = "(#{loop_index}+=1 ; #{loop_end} - #{loop_index})"
      push expression
      :indent_down
    when 27 # rts_OpForStep
      loop_end = pop
      loop_step = pop
      loop_index = pop
      expression = "(#{loop_index}+=#{loop_step} ; #{loop_end} - #{loop_index})"
      push expression
      :indent_down
    when 28 # rts_OpPop
      pop
    else
      raise NotImplementedError, "Implement vm_oper (#{i}) at line #{@current_line}"
    end
  end

  def vm_genList(args)
    list_size = args_to_index(args)
    items = pop(list_size)
    push items
  end

  def vm_goto(args)
    offset = args_to_signed(args)
    target_ip = @ip + offset 
    label = "l_#{target_ip}"
    @labels[target_ip] = label
    push "goto :#{label}"
    :statement
  end

  def vm_jpz(args)
    offset = args_to_signed(args)
    expression = pop
    target_ip = @ip + offset 
    label = "l_#{target_ip}"
    @labels[target_ip] = label
    push "if ! #{expression} then goto :#{label} ; end"
    :statement
  end

  def vm_jnz(args)
    offset = args_to_signed(args)
    expression = pop
    target_ip = @ip + offset 
    label = "l_#{target_ip}"
    @labels[target_ip] = label
    push "if #{expression} then goto :#{label} ; end"
    :statement
  end

  def vm_jpe(args)
    expr_capture = ""
    test_variable = "tmp_#{@case_statement_start_ip}"
    if @case_statement_start_ip == @current_ip
      # capture last expression value with single underscore
      expr_capture = "#{test_variable} = _ # Capture last expression value for use in this case-like structure\n"
    end
    compare = args_to_signed([args[0],args[1]])
    offset = args_to_signed(args[2..])
    target_ip = @ip + offset 
    label = "l_#{target_ip}"
    @labels[target_ip] = label
    push "#{expr_capture} if #{test_variable} == #{compare} then goto :#{label} ; end"
    :statement
  end

  def vm_jpc(args)
    offset = args_to_signed(args)
    expression = pop
    target_ip = @ip + offset 
    label = "l_#{target_ip}"
    @labels[target_ip] = label
    push "if #{expression} < 0 then goto :#{label} ; end"
    :statement
  end

  def vm_jnc(args)
    offset = args_to_signed(args)
    expression = pop
    target_ip = @ip + offset 
    label = "l_#{target_ip}"
    @labels[target_ip] = label
    push "if #{expression} >= 0 then goto :#{label} ; end"
    :statement
  end

  def vm_pushInt(args)
    int = args_to_signed(args)
    push int
  end

  def vm_retAll(args)
    list_size = args_to_index(args)
    rets = pop(list_size).map{|a| a.to_s}
    push "return #{rets.join(', ')}"
    :statement
  end

  def vm_ret(args)
    push "return"
    :statement
  end

  def vm_popArg(args)
    local_index = args_to_index(args)
    local = @function.locals[local_index]
    @function.arg_list ||= []
    @function.arg_list << local.name
  end

  def vm_repSetOp(args)
    push "Reporting.get_report_operation()"
    :statement
  end

  def vm_callRep(args)
    function_index = args_to_index(args[0..1])
    function = @file.functions.values[function_index]
    arg_count = args_to_index(args[2..3])
    call_args = pop(arg_count)
    push "Reporting.call #{function.name}(#{call_args.join(', ')})"
    :statement
  end

end
