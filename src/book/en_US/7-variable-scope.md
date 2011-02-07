## Scope of Variables

There are two kinds of variables in Lua, local and global. Globals are visible
throughout the _whole_ program,  The standard functions in Lua are mostly contained
in global tables, like `math` and `table`.  An assignment like this:

    newGlobal = 'hello'

causes `newGlobal` to be publically available - it is not just visible in the declared file.

Global variables are contained in the global table. The variable `_G` refers to this
table explicitly, so `_G.print` works as expected.  But otherwise there is nothing special
about `_G` and setting it to some other value has no effect on program operation.

To understand global functions you need to remember how tables and functions work.
It is easy to change the behavior of the whole program by redefining a global:

    function print(x)
        io.write(tostring(x),'\n')
    end

This is _totally_ equivalent to the following table key assignment:

    _G["print"] = function(x) ... end

So you will not be surprised when this causes unexpected behavior - suddenly every
call to `print` works differently (since the new version only takes one argument.)
Sometimes this technique is useful and it has a name: "monkey patching". But
generally it is a disaster waiting to happen, because it messes with people's
expectations of how a standard function works.

Lua can not tell you that a function is undefined at compile-time. If you misspell a name
`newGlbal` then it will just tell you that you have tried to call a `nil` value, because
`_G["newGlbal"]` is `nil`.

Local variables, on the other hand, are only visible in the block where they have
been declared.

There are two places where local variables are implicitly declared; the first is the
argument list of a function, and the second is the variables defined by a `for`
statement. In this function, `x`,`y` and `z` are local because they are arguments,
and `k`,`v` are locals because they are `for` variables.

    function fun(x,y,z)
        for k,v in pairs(x) do
            ....
        end -- B2
        print(k)
    end -- B1

Local variables always have a 'scope', which is the the part of the program where
they are valid and visible.  In this function, `x` is visible up to the end of block
B1 and `k` is visible up to the end of block B2. In particular, `k` is not visible in
`print(k)`! And If a variable is undeclared, then Lua assumes it is global.

The problem then is that a misspelling is _not an error_ , just `nil` !

Locals may be explicitly defined using the `local` keyword. This function makes a
'shallow copy' of a table by creating a new table and copying the key/value pairs:

    function copy (t)
        local res = {}
        for k,v in pairs(t) do
            res[k] = v
        end
        return res
    end

`local` is the correct way to do this, because then the variable `res` is not visible
outside the function.  The function is 'pure', i.e. it has no global side-effects.

Local declarations can 'nest' inside each other. Inside the for-loop, `k` has a different
meaning to `k` outside the loop.

    function dumpv( t )
        local k = 1
        for k.v in pairs(t) do
            print(k,v)
        end
        print(k) -- 1  !
    end

Good programming practice is to make everything as local as possible.  As a bonus,
accessing locals is significantly faster than accessing globals.  Each global access involves
a table lookup, whereas locals define 'slots' which are much more efficient.
