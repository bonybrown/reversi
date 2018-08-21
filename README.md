# reversi
General mischief arising from finding `fglrun -r`

## reversi.rb

Takes the output of `fglrun -r` and turns it into a 
ruby-like approximation of the source code.

There's plenty of work still to be done until
the result is like `substr.rb` below.

## substr.rb

This is a hand-modified version of a function
generated from `reversi.rb` that is able to be
run:
```
ruby -r './substr' -e "puts Substr::wh_delim_count('3/3/2/4','/')"

=> 3
```

Features of `substr.rb` are that blocks of
code are sectioned into lambdas based on the
labels defined in the decompilation. GOTO statements
are implemented as early `return`s from the lambda
with the returned value being a symbol referencing the GOTO target's label.

When each lambda is invoked, the return value is checked
to see if it is a symbol reference to another lambda block.

If so, that code block is is called.

If not, the logically `next` lambda block in the code flow
is called.

*TODO:* may need to return some kind of return object that indicates an 
_actual_ return statement has been executed, to cater
for early returned functions.
