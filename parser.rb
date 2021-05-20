class Parser
  
  attr_reader :lines, :labels, :types, :variable_types
  def initialize( output_style , global_finder)
    @output_style = output_style
    @state = :header
    @stack = []
    @line_number = 1
    @lines = {}
    @labels = {}
    @in_case = false
    @types = {}
    @type_id = 0
    @type_state = :normal
    @variable_types = {}
    @function_started = false
    @locals = {}
    @globals_resolved = false
    @globals = {}
    @pending_function_start = false
    @pending_label = nil
    @global_finder = global_finder
  end
  
  def store_type( type_id, type )
    if @type_state == :record
      if type_id.to_i > 0
        @type_state = :normal
      else
        @types[@type_id] << type_id
      end
    end
    if @type_state != :record
      @type_id = type_id.to_i
      if type == 'RECORD'
        @type_state = :record
        type = []
      end
      @types[@type_id] = type
    end
  end
  
  def get_type_of( type_id )
    type_id = type_id.to_i
    td = @types[type_id]
    while td.to_s.match(/^ARRAY/) && type_id >= 0
      type_id -= 1
      td = @types[type_id]
    end
    td
  end
  
  def output_variable_declaration( decl )
    (@output_style == :human ? $stdout : $stderr).puts decl
  end
  
  def store_global( name, definition )
    output_variable_declaration "GLOBAL #{name} #{definition}"
    @globals[name] = definition
  end
  
  def resolve_globals
    if !@globals_resolved
      @globals.each_pair do |k,v|
        if v=='RECORD'
          index = @global_finder.get_global_type_index(k)
          @globals[k] = get_type_of(index)
        else
          @globals[k] = @types.select{|a,b| b==v}.keys[0]
          @globals[k] = get_type_of(@globals[k])
        end

        #@globals[k] = %W(program_id version fund_id sub_fund state_code wrk_grp message function table mode sqlcode from_dte to_dte request rep_pprog instal_flags thread_id) if k == 'rw500'
        #@globals[k] = %W(lu_user lu_term lu_time desc xcheck prefix code) if k == 'rw070d'
        output_variable_declaration "GLOBAL #{k} is #{@globals[k]}"
      end
    end
    @globals_resolved = true
  end
  
  def store_variable( name, type_id, type_name )
    if name == 'PRIVATE'
      name = type_id
      type_id = type_name
    end
    @variable_types[name] = get_type_of( type_id )
    output_variable_declaration "VARIABLE #{name} is #{@variable_types[name]}"
  end

  def store_local( name, type_id, type_name )
    @locals[name] = get_type_of( type_id )
    output_variable_declaration "LOCAL #{name} is #{@locals[name]}"
  end

  def parse( line, index )
    #part = line.scan(/`[^']+'|\S+/)
    @input_line_number = index
    part = line.scan(/\S+/)
    part.each do |v|
      v[0] = '\'' if v[0] == '`'
    end
    #p part

    if @state != :body && @state != :locals
      case line
      when /Function/
        resolve_globals
        @state = :body
      when /Global variables:/, /Globals/
        @state = :globals
      when /Module variables:/
        @state = :variables
      when /Number of types:/
        @state = :type
      when /Number/, /Module/
        @state = :header
      else
        case @state
        when :globals
          store_global( part[0], part[1..10].join(' ') )
        when :variables
          store_variable( part[0], part[1] , part[2] )
        when :type
          store_type( part[0], part[1..10].reject{|s| s.match(/s:\d+/)}.join(' ') )
        end
      end
    end
    if @state == :locals
      case
      when line.length > 60 || line.match(/line \d+:/)
        @state = :body
      else
        store_local( part[0], part[1] , part[2] )
      end
    end
    if @state == :body
      case
      when line.match(/Locals variables:/)
        @state = :locals
      when part[0] == 'line'
        r_line part
      when part[0] == 'Function'
        r_function part
      else
        r_body part if !part.empty?
      end
    end
  end
  
  def label( value )
    #@labels[@line_number] = value
    @pending_label = value
  end
  def line( value )
    #puts "LINE: #{@line_number} #{value}"
#     while( @lines[@line_number] )
#       @line_number +=1
#     end
    @lines[@line_number] = [] if @lines[@line_number].nil?
    
    @lines[@line_number] << @pending_label unless @pending_label.nil?
    @lines[@line_number] << "\t" + value
    @pending_label = nil
  end
  
  
  def function_arity( funcspec )
    data = funcspec.split(/[()]/)
    [data[0],data[1].to_i]
  end
  
  def numeric( value )
    value.gsub(/[^0-9]/,'').to_i
  end
  
  def is_numeric(value)
    value.gsub(/'/,'') == numeric(value).to_s
  end
  
  def r_body(part)
    

    # This is the list of operations 
    # extracted from a body of code.
    # Those marked with * are not yet implemented
    #   rts_Op1Clipp(1)
    # * rts_Op1Column(1)
    #   rts_Op1IsNotNull(1)
    #   rts_Op1IsNull(1)
    #   rts_Op1Not(1)
    # * rts_Op1Spaces(1)
    #   rts_Op1UMi(1)
    #   rts_Op2And(2)
    #   rts_Op2Di(2)
    #   rts_Op2Eq(2)
    #   rts_Op2Ge(2)
    #   rts_Op2Gt(2)
    #   rts_Op2IntMi(2)
    # * rts_Op2IntMu(2)
    #   rts_Op2IntPl(2)
    #   rts_Op2Le(2)
    #   rts_Op2Lt(2)
    #   rts_Op2Mi(2)
    #   rts_Op2Mo(2)
    #   rts_Op2Mu(2)
    #   rts_Op2Ne(2)
    #   rts_Op2Or(2)
    #   rts_Op2Pl(2)
    #   rts_Op2Test(2)
    #   rts_OpFor(2)
    #   rts_OpForStep(3)
    #   rts_OpPop(1)
        
    label = ''
    case part[0]
    when /l_\d+/
      label part.shift + ': '
    end

    case part[0]
    when 'oper'
      part.shift
    end
    
    case part[0]
    when 'pushNull'
      @stack.push 'nil'
    when 'pushInt'
      @stack.push numeric(part[1]).to_s
    when 'pushCon'
      if is_numeric(part[1])
        @stack.push numeric(part[1]).to_s 
      else
        string = part[1..part.length].join(' ')
        rindex = string.rindex("'")
        index = string.index("'")
        @stack.push '"' + string[index+1..rindex-1].gsub('"','\"') + '"'
      end
    when /^push/
      @stack.push part[1]
    when 'assF'
      value = @stack.pop
      line "#{@stack.pop} = #{value}"
    when 'assR'
      value = @stack.pop
      line "#{@stack.pop} = #{value} #WARNING: assR unverified"
    when 'load'
      load_count = part[1].to_i
      args = []
      load_count.times do
        args.unshift @stack.pop
      end
      @stack.push "#{args.join(', ')} = #{@stack.pop}"
    when 'retAll'
      ret_count = part[1].to_i
      args = []
      ret_count.times do
        args.unshift @stack.pop
      end
      if ret_count == 1
        line "RETURN #{args[0]}"
      else
        line "RETURN [#{args.join(', ')}]"
      end
    when /call[N\d]/
      name,arg_count = function_arity( part[1] )
      args = []
      arg_count.times do
        args.unshift @stack.pop
      end
      case name
      when '<builtin>.rts_doCat'
        @stack.push "#{args[0]} = #{args[1]}.join"
      when '<builtin>.length'
        @stack.push "#{args[0]}.length"
      when '<builtin>.rts_forInit'
        line "#{args[0]} = #{args[1]} # FOR LOOP( #{args[0]} = #{args[1]} ; #{args[0]} += #{args[2]} ; #{args[0]} <= #{args[3]})"
        @stack.push "(#{args[3]} - #{args[0]})"
      else
        @stack.push "#{name}(#{args.map{|v|v.to_s}.join(',')})"
      end
    when 'arrSub', 'strSub', 'strSubL'
      subscript = @stack.pop
      @stack.push "#{@stack.pop}[#{subscript}]"
    when 'strSub2', 'strSubL2'
      end_pos = "(#{@stack.pop} - 1)"
      start_pos = "(#{@stack.pop} - 1)"
      @stack.push "#{@stack.pop}[#{start_pos}..#{end_pos}]"
    when 'genList'
      count = part[1].match((/\d+/))[0].to_i
      args = []
      count.times do
        $stderr.puts "stack underflow in genList (input line #{@input_line_number})" if @stack.length == 0
        args.unshift @stack.pop
      end
      @stack.push "[#{args.join(', ')}]"
    when 'member'
      stack_top = @stack.pop
      var_name = stack_top.split('[')[0]
      type = @locals[var_name] || @variable_types[var_name] || @globals[var_name] || {}
      member_index = part[1].to_i
      @stack.push "#{stack_top}.#{type.fetch(member_index){'unknown_member:' + member_index.to_s}}"
    when 'extend'
      operand = @stack.pop
      var_name = operand.split('[')[0]
      type = @locals[var_name] || @variable_types[var_name] || @globals[var_name] || ["UNKNOWN MEMBERS"]
      $stdout.puts "ERROR EXTENDING #{operand}" unless type.respond_to? :each
      type.each do |member|
        @stack.push "#{operand}.#{member}"
      end
    when 'ret'
      line 'RETURN'
    when 'rts_Op1Clipp(1)'
      @stack.push "#{@stack.pop}.rstrip"
    when 'rts_Op2Eq(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} == #{rhs})"
    when 'rts_Op2Ne(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} != #{rhs})"
    when 'rts_Op2Lt(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} < #{rhs})"
    when 'rts_Op2Le(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} <= #{rhs})"
    when 'rts_Op2Gt(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} > #{rhs})"
    when 'rts_Op2Ge(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} >= #{rhs})"
    when 'rts_Op2Or(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} || #{rhs})"
    when 'rts_Op2And(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} && #{rhs})"
    when 'rts_Op2Pl(2)', 'rts_Op2IntPl(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} + #{rhs})"
    when 'rts_Op2Mu(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} * #{rhs})"
    when 'rts_Op2Mo(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} % #{rhs})"
    when 'rts_Op2Di(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} / #{rhs})"
    when 'rts_Op1UMi(1)' #unary minus
      @stack.push "(-#{@stack.pop})"
    when 'rts_Op2Mi(2)', 'rts_Op2IntMi(2)'
      rhs = @stack.pop
      @stack.push "(#{@stack.pop} - #{rhs})"
    when 'rts_Op1IsNotNull(1)'
      @stack.push "(!#{@stack.pop}.nil?)"
    when 'rts_Op1IsNull(1)'
      @stack.push "(#{@stack.pop}.nil?)"
    when 'rts_Op1Not(1)'
      @stack.push "(!#{@stack.pop})"
    when 'rts_Op2Using(2)'
      fmt = @stack.pop
      @stack.push "( #{@stack.pop}.format(#{fmt}) )"
    when '*jpe'
      #TODO this is a case statement
      unless @in_case
        line "case #{@stack.pop}:"
      end
      line "  when #{part[1]} GOTO #{part[2]}"
    when '*jpz'
      line "IF NOT #{@stack.pop} GOTO #{part[1]}"
    when '*jnz'
      line "IF #{@stack.pop} GOTO #{part[1]}"
    when '*jnc'
      line "IF #{@stack.pop} >= 0 GOTO #{part[1]} #WARNING: *jnc unverified  OpFor"
    when '*jpc'
      line "IF #{@stack.pop} < 0 GOTO #{part[1]} #WARNING: *jpc unverified NEXT LOOP"
    when '*goto'
      line 'GOTO ' + part[1] 
    when '-ExceptionTable:'
      line 'ON ERROR DO SOMETHING #probably this on next line'
    when 'popArg'
      var_num = numeric(part[1])
      line "#{@locals.keys[var_num]} = FUNCTION_ARGUMENT(#{var_num}) # #{@locals[@locals.keys[var_num]]}"
    when 'rts_Op2Test(2)'
      test_var = @stack.pop
      against = @stack.pop
      line "local_test_value = #{against}" unless against.nil?
      @stack.push "#{test_var} == local_test_value"
    when 'rts_OpFor(2)'
      loop_limit = @stack.pop
      loop_var = @stack.pop
      line "#{loop_var} += 1 # FOR LOOP NEXT #{loop_var}"
      @stack.push "(#{loop_limit} - #{loop_var})"
    when 'rts_OpForStep(3)'
      loop_limit = @stack.pop
      loop_step = @stack.pop
      loop_var = @stack.pop
      line "#{loop_var} += #{loop_step} # FOR LOOP NEXT #{loop_var} STEP #{loop_step}"
      @stack.push "(#{loop_limit} - #{loop_var})"
    when 'callRep'
      arg_count = part[2].to_i
      report_id = part[1]
      line "CALL REPORT #{report_id} with #{arg_count} args"
      args = []
      arg_count.times do
        $stdout.puts "stack underflow" if @stack.length == 0
        args.unshift @stack.pop
      end
      line "call_report #{report_id}, [#{args.join(', ')}]"
    when 'rts_OpPop(1)'
      line "local_test_value = nil # rts_OpPop(1) squashed here"
    else
      line "!!UNHANDLED OPERATION: #{part}"
    end
    
    @in_case = part[0] == '*jpe'
  end
  def r_line(part)
    #puts "R_LINE #{part}"
    @line_number = part[1].to_i unless @lines[part[1].to_i]
    line "FUNCTION #{@pending_function_start}" if @pending_function_start
    @pending_function_start = false
    while p=@stack.pop
      line p + " # line left on stack"
    end
    #@stack.clear
  end
  def r_function(part)
    if @function_started
      line "END FUNCTION"
    end
    @pending_function_start = parse_function_name(part[1] )
    @function_started = true
    @locals.clear
  end
  
  def parse_function_name(value)
    p = value.split('(')
    p[0]
  end
end
