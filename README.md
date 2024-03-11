# reversi
General mischief arising from finding the `fglrun -r` command that
dumps the content of a `.42m` file into a human readable listing
showing the types, constants, variables and function op codes in that file.

## The FGL runtime
Seems like the FGL runtime is a stack based VM, similar to a Java VM.

For example, this sequence assigns the constant `0` to the global variable `gv_fatal`

```
       pushGlb   gv_fatal                  05 07
       pushCon   `0'                       07 01
       assF                                0f
```
The opcodes for each of the instructions are on the right. Constants, functions and variables
are referenced by their index in tables for each kind of object. Each constant and variable
has a data type, again referenced by index into a "types" table.

The bytecode format is essentially machine code level. 
Conditional constructs like `if` and `case` are implemented as jumps.

```
       pushGlb   status                    05 01
       pushCon   `0'                       07 01
       oper      rts_Op2Eq(2)              1a 09
       *jpz      l_613                     22 05
       pushLoc   fv_found                  01 02
       pushCon   `1'                       07 00
       assF                                0f
l_613  *goto     l_617                     1e 02
```
This sequence can be interpreted as
```
if !(status == 0) then
    goto l_613
else
    fv_found = 1
end

l_613:
    goto l_617
```
That could be refined further as:
```
if status == 0 then fv_found = 1
```

### The FGL 42m file format
The 42m file looks to be a series of "tables" for types, constants, variables
(of global, module and function scope), functions (both those defined in the file,
and referenced functions in other files), and the function code itself.
Reverse engineering resources for the `.42m`
file format are in the `/doc` directory.

## reversi.rb

Takes a `.42m` file and turns it into a 
ruby-like approximation of the source code.

Because `if` and `case` statements are
implemented as jumps, and ruby doesn't support jumps
the output uses the [goto](https://github.com/bb/ruby-goto)
gem to emulate this. The code doesn't do any flow analysis
to optimise the jumps into simplier `if...then...else` blocks.

## Output Formats
***Not really implemented yet***

The `--output` command line switch controls the output format
of the command.

Options are:

### human (default)

This output is the most human readable. Line numbers usually
do not align with the original source, and original lines of
code are sometimes split over several lines.

## debug

In this output, the output lines match the original source.

This format is suitable for use with the fglrun debugger.

## executable (this is the current default)

This format is to be in a form of ruby code that can be
executed. It will contain code blocks in a hash of proc
objects and could be quite hard to read.


## Useful links

FourJs documentation downloads (user manuals for GDC, etc) [http://4js.com/download/documentation](http://4js.com/download/documentation)

FourJs online documentation [http://4js.com/online_documentation/fjs-fgl-3.00.02-manual-html/index.html](http://4js.com/online_documentation/fjs-fgl-3.00.02-manual-html/index.html).
This has details of all the built-in functions, so can be used as a reference for implementation of methods and keywords.
