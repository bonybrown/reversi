

class Builtin
  def self.rts_sql_select(statement, into_vars, use_vars )
    puts statement.gsub('?',use_vars.to_s)
    result = [43,'hello'] # result of exec statement, using use_vars
    into_vars.call( result )
  end
  
  def self.rts_sql_intovars( var_array )
    #need to inline into a lambda that assigns results to variables, like:
    # lambda {|r| x = r[0]; y = r[1]}
    # "lambda{|r|"+var_array.each.with_index.map{|v,i|"#{v}=r[#{i}];"}.join+"}"
  end
  
  def self.rts_sql_usevars( var_array )
    var_array
  end
    
  def self.upshift( value )
    value.to_s.upcase
  end

  def self.downshift( value )
    value.to_s.downcase
  end
end



class Foo

  def self.func()
    x = 5
    y = 6
    z = 7

    var_array=['a','b','c']
    puts "lambda{|r|"+var_array.each.with_index.map{|v,i|"#{v}=r[#{i}];"}.join+"}"
    
    Builtin::rts_sql_select("select x,y from table where x=?", lambda{|r|x=r[0];y=r[1]}, Builtin.rts_sql_usevars([z]) )

    p x,y

  end

end

Foo::func
