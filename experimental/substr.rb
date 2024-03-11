module Substr
  
  def self.go( procs , *args)
    ordered_code = procs.keys
    call_key = :entry
    result = procs[call_key].call( *args )
    while call_key
      if result.is_a?(Symbol) && result.to_s.match(/^l_\d+$/)
        call_key = result
      else
        index = ordered_code.index(call_key)
        call_key = nil
        if index
          call_key = ordered_code[index.succ]
        end
      end
      if call_key.nil?
        return result
      end
      #puts "CALLING: #{call_key}"
      result = procs[call_key].call
    end
  end
    
  
  def self.wh_delim_count( *args )
    fv_delimiter = ''
    fv_string = ''
    fv_count = 0
    fv_len = 0
    fv_idx = 0
    procs = {}
    procs[:entry] = lambda do |*function_arguments|
      #                      ON ERROR DO SOMETHING #probably this on next line
      fv_delimiter = function_arguments[1] # CHAR(1)
      fv_string = function_arguments[0] # CHAR(513)
      fv_count = 0
      fv_len = fv_string.length
      fv_idx = 1 # FOR LOOP( fv_idx = 1 ; fv_idx += 1 ; fv_idx <= fv_len)
      if (fv_len - fv_idx) < 0 
        return :l_59 #WARNING: *jpc unverified NEXT LOOP
      end
    end

    procs[:l_31] = lambda do
      #puts "'#{fv_delimiter}', '#{fv_string}', #{fv_count}, #{fv_len}, #{fv_idx}"
      if not (fv_string[fv_idx] == fv_delimiter) 
        return :l_51
      end
      fv_count = (fv_count + 1)
    end

    procs[:l_51] = lambda do
      fv_idx += 1 # FOR LOOP NEXT fv_idx
      if (fv_len - fv_idx) >= 0 
        return :l_31 #WARNING: *jnc unverified  OpFor
      end
    end

    procs[:l_59] = lambda do
      return fv_count
    end
    
    go( procs, *args)
  end
end

