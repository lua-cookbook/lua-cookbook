## Errors

Because Lua functions may return multiple values, they can return error strings
together with the status code.  The classic example is `io,open` which usually
returns a file object, but will return both a `nil` and an error message if the file
cannot be opened:

    > = io.open("hello.txt")
    nil	hello.txt: No such file or directory	2

However, the Lua libraries aren't consistent in error handling. The `table` functions
throw errors:

    > t = {'h',{}}
    > = table.concat(t)
    stdin:1: invalid value (table) at index 2 in table for 'concat'
    stack traceback:
        [C]: in function 'concat'
        stdin:1: in main chunk

Even in the most careful programs, something will go wrong, and you do not
want users to witness a crash with a stack traceback.  Also, it is often possible
to recover from the situation.  Languages with exception handling
encourage the 'throwing' or 'raising' of errors because then the error handling
code is kept away from the 'normal' logic - what is sometimes called
'the happy path'.

There is no `try/except` statement in Lua, but there is a function `pcall`
(or 'protected call') which will call a Lua function safely. It will return the status
and anything returned by the function. If the status is `false`, then the second
return value is the error message.

    > = pcall(table.concat,t)
    false	invalid value (table) at index 2 in table for 'concat'
    > = pcall(table.concat,{'one','two'})
    true	onetwo

Anonymous functions are useful for blocks that can raise errors:

    local status,err = pcall(function()
        do_something()
        do_another()
        and_again()
    end)
    if not status then
        print('error',err)
    end

You can raise your own errors, using `error`. In its simplest form it will indicate
that the error came from the current line:

    --> error is reported at this line; program will give a stacktrace
    if not right then error("was not right!") end

There can also be a second parameter that indicates where the error came from:

    function not_right_error()
      error("was not right",2) -- i.e, _calling_ function raised this
    end

    --> error still reported at this line
    if not right then not_right_error() end

The function `assert` raises an error if a condition fails:

    --> message 'assertion failed...."
    assert(n > 0)
    --> message "size must be positive"
    assert(n > 0,"size must be positive")

The equivalent Lua version looks like this:

    function assert(value,message)
        if not value then
            if message == nil then message = "assertion failed" end
            error(message,2)
        else
            return value
        end
    end
