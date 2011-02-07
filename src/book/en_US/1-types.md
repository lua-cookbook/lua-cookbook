## Types

The standard function `type` returns the type of any Lua value:

    type("") == "string"
    type(0) ==  "number"
    type({})) == "table"
    type(print) == "function"
    type(nil) == "nil"

### `nil`

`nil` is a special case; other languages call it `NULL`, `nil`,`Nothing`,`null`,etc.
It is however a valid value and has a definite type, which is 'nil'.

Only `nil` and the boolean `false` values make conditions fail.

Otherwise, `nil` is special when used with tables; table elements cannot be `nil`.

Be particularly careful when putting `nil` values into an array; these will become
'holes' and the value of `#arr` will become invalid.

### Booleans

A boolean value is either `true` or `false`. The conditional operators, like `>`
and `==` return this value. The standard boolean operators `and` and `or` will
usually also return 'boolean'.

Only `false` and `nil` make a condition fail.

    a = 5
    print(a > 4)  --> true
    print(a == 4) --> false
    print(a > 4 and a < 10) --> true

### Numbers

Lua has only one type of number, which is usually double-precision floating-point on
desktop machines. This means you do not usually have to worry about integers and
floats;  this is one of the simplifications which makes Lua so small and fast. If
you worry about storing integers as double-precision floats, remember that integers
can be _exactly_ represented up to about 1e16.

There are two rounding functions, `math.floor` and `math.ceil`; so given 3.1, the
first gives the integer part (3), and the second gives the first integer that is
larger (4). `math.ceil(x)==x` is only true if `x` is an integer.

    function is_integer (x)
        return math.ceil(x) == x
    end

0 does not fail a condition, unlike C or Python.

### Strings

A Lua _string_ is usually quoted text, but can actually include any byte value,
including the so-called null byte.  (You can for instance read a binary file into a
Lua string without any corruption.)

Both single and double quotes can be used, with no change in meaning - this is
useful if you wish to quote a string inside a string:

   message = "cannot find: 'dolly'"

The best advice is: be consistent in your quoting.

Strings compare as you would expect using the locale, so that `s1==s2` behaves
sensibly, unlike in Java. In Lua, identical strings are _identical_ objects.

There are cases where strings will be automatically considered to be numbers. For
instance, `"2"+"3"` will be the number 5. But if any of the strings cannot be
converted into a number, then there will be an error: "attempt to perform arithmetic
on a string value". It isn't a good idea to depend on this default behaviour,
because your program will crash on bad input.

The length operator `#` returns the number of bytes in a string, which is not
necessarily the number of characters.

### Tables

Lua tables are _associative arrays_; indexing a table is giving it a _key_ and getting a value.
Any Lua value can be stored in a table, except for `nil`.

They are very efficient at _behaving_ like arrays, that is, consecutive integer keys starting
at one.  The length operator `#` only gives the number of these keys, not the total
number of keys.

### Functions

In Lua, functions are _first-class values_ - that is, they can be passed around like any other value.

### Coroutines

### Userdata




