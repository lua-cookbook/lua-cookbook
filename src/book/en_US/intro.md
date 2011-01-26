# An Introduction to Lua

This introduction assumes that you have some familiarity with basic programming.

We recommend that you get a good programmer's editor which understands Lua syntax
and can highlight it appropriately. This is not just because it's more attractive,
but such an editor can immediately show you common mistakes like forgetting the
closing quote on a string.  Such editors can also match up parentheses and braces.
They will often automatically _indent_ code for you, which is important for
readability..

A good start is the Lua [wiki](http://lua-users.org/wiki/LuaEditorSupport). If you
are on Windows, then the Lua for WIndows distribution comes with SciTE, which also
has Lua debugging support.

## Basics

### Expressions

It is traditional to start with "Hello, world". Like all scripting languages, this
is straightforward:

    print("Hello, world")

An important point is that `print` is a function which takes a number of values and
prints out these values to standard output. It is not a statement, as in Python 2.X
or Basic.

Arithmetic expressions use standard programming notation:

    print("result",2*3.5*(1 - 0.1)^2)

There is an exponentiation ('power of') operator `^`, unlike in C or Java.

`x^y` can also be written explicitly as `math.pow(x,y)`. There are the usual
standard mathematical functions available in the `math` namespace (or _table_) like
`math.sin`, `math.sqrt`,etc. The useful constant `math.pi` is also available.

    print('sin',math.sin(0.5*math.pi),'cos',math.cos(0.5*math.pi))

This is more readable when spread over two lines using a _variable_ `x`:

    x = 0.5*math.pi
    print('sin',math.sin(x),'cos',math.sin(x))

Of course, you could say that `x` is not a variable, but Lua does not make any such
distinction.

### Variables and Assignment

Lua variables may have letters, digits and underscores ('_'). They may refer to any
Lua type:

    x = "hello"
    x = 1
    x = x + 1

Here, the value of `x` becomes "hello", and then it becomes 1, and finally 2 (which
is the value of `x + 1`).  Variables have no fixed type, but always contain a
definite type of value, even if it is just `nil`.

Assigning multiple variables works like this:

    x,y = 1,2

This sets `x` to 1 and `y` to 2. This is different from the usual `x=1,y=2` style in
other languages. It is possible to swap the values of two variables in one line:

    x,y = y,x

### Functions

It is straightforward to create your own functions. Here is a sine function which
works in degrees, not radians.

    function sin(x)
        return math.sin(math.pi*x/180.0)
    end

That is, after the keyword `function` there is the function name, an _argument list_
and a group of statements ending with `end`. The keyword `return` takes an
expression and makes it the value returned by the function.

### Simple Loops

Programming is more than calculation. The simplest way to do something a number of
times is the _numerical for_ statement:

    for i = 1,5 do
        print("hello",i)
    end

Any statements in the _block_ from `do` to `end` are repeated with different values
of the variable `i`.

Spacing and line ends (often called 'whitespace') is usually not important. This
code could also be written like so:

    for i = 1,5 do print("hello",i) end

or

    for i = 1,5
    do
    print("hello",i)
    end

However, the last example would be considered bad style. The logic of a program is
much easier to follow if statements are laid out at the right columns.

The `for` statement loops from a start to a final value, inclusive. There can be a
third number, which is the 'step' used in calculating the next value. So to print a
little table of sine values from 0 to &pi; with steps of 0.1 is simple:

    for x = 0,math.pi,0.1 do
        print(x,math.sin(x))
    end

There is something you need to know about `for` variables; they only exist inside
the block.

    for i = 1,10 do print(i) end
    print(i)

You might expect that the last value printed would be 11, but the last `print` will
show just `nil`; `i` is _not defined_ outside the loop.

### Conditions

Programs often have to make choices.

    age = 40
    if age > 30 then
        print("too old to play games!")
    end

(Well, that's rude, but computers often are. You can't please everyone.)

The expression in the `if` statement is called a _condition_. For intance,
`10 == 10` is always `true`; `2 >= 3` (meaning 'greater or equal') is always `false`.

Like Python and the C-like langauges `==` is used for 'is equal', since a single `=`
has a very different meaning. Unlike them, 'not equal' is `~=` (the tilde `~` is
usually the key on the far left side, next to `!`)

`if-else` statements can be combined together: note that it is the single word
`elseif` rather than the two words `else if`.

    age = 18
    if age == 18 then
        print("just right")
    elseif age > 30 then
        print("too old")
    else
        print("too young")
    end

Conditional expressions can be combined with `and` or `or`:

    a > 0 and b > 0 or a == 0 and b < 0

In this expression, `>` and `==` evaluate first, followed by `and`, and then `or`.
So the explicit form would be:

    ((a > 0) and (b > 0)) or ((a == 0) and (b < 0))

Lua will 'short-circuit' logical expressions, For example, `n > 0` here will give an
error if `n` is not a number:

    if type(n) == 'number' and n > 0 then .... end

But Lua will not bother to evaluate `n > 0` in that case.

`if` statements can be used inside the `for` statement:

    for i = 1,10 do
        if i < 5 then
            print("lower",i)
        else
            print("upper",i)
        end
    end

Now, just to make a point, here is that code again:

    for i = 1,10 do
    if i < 5 then
    print("lower",i) else
    print("upper",i)
    end
    end

The logical structure of the code is now harder to see. By making indenting a habit,
you will write code that will be more readable to another person. (After several
months, you will be that other person.)


### Loops with Conditions

This produces the same output as the simple `for` statement example:

    i = 1
    while i < 10 do
        print("hello",i)
        i = i + 1
    end

### Arrays

Arrays in Lua are done using _tables_, which is a very general data structure. A
simple array is easy to define:

    arr = {10,20,30,40}

and then the first element will be `arr[1]`, etc; the length of the array is `#arr`.
So to print out this array:

    for i = 1,#arr do print(arr[i]) end

(Yes, arrays start with index 1; it's best to accept this and learn to live with the
fact.)

These arrays are resizable; we can add new elements:

    arr[#arr+1] = 50

and insert elements at some position using the standard function `table.insert`; the
second argument is the index _before_ where the value is inserted.

    table.insert(arr,1,5)

After these two operations the array now looks like `{5,10,20,30,50,50}`.

To complete the picture, there is `table.remove` which removes a value at a given
index.

What about trying to access an array element that does not exist, e.g. `arr[20]`? It
will not raise an error, but return the value `nil`.  So it is wise to carefully
check what is returned from an arbitrary array access.  Since `nil` always indicates
'not found', it follows that you should not put `nil` into an array.

Consider this:

    a1 = {10,20}
    a2 = {10,20}
    print(a1 == a2)

The result is `false` because `a1` and `a2` are different _objects_. Table
comparison does not compare the elements, it just checks whether the arguments are
in fact the same tables.

Newcomers to Lua are often surprised by the lack of 'obvious' functionality, like
how to compare arrays 'properly' or how to print out an array. It helps to think of
Lua as 'the C of dynamic languages' - lean and mean. It gives you a powerful core
and you either build what you need, or reuse what others have provided, just as with
C.

There are a number of useful places to find this extra functionality, such as the
[lua-users](http://lua-users.org/wiki/) wiki. And the whole purpose of the Lua
cookbook is to provide good solutions so you do not have to reinvent the wheel.

Lua arrays (like their Python counterpart, lists) can contain any valid Lua value:

    t = {10,'hello',{1,2}}

So `t[1]` is a number, `t[2]` is a string, and `t[3]` is itself another array.

### Maps (associative arrays)

The term 'map' means a data structure which looks up a 'key' and returns its
associated value; it is often called a 'hash' or a 'dictionary'. Maps in Lua are
declared almost the same way as arrays:

    M = {one=1,two=2,three=3}

`M` operates like an array with string indices, so that we have:

    print(M['one'],M['two'],M['three'])
    --> 1   2   3

As with arrays, an unknown key always returns `nil`. (Unlike Python or Java, where
an unknown key will cause an error.)

To iterate over all the keys and values requires a different `for` loop syntax:

    for key,value in pairs(M) do print(key,value) end
    --> one     1
    --> three   3
    --> two     2

The `pairs` function creates an _iterator_ over the map key/value pairs which the
`for in` statement goes through.

This example illustrates an important point; the _actual_ order of iteration is not
the _original_ order.  (In fact the original order is lost, and extra information
needs to be stored if you want the keys in a particular order.)

In Lua, `M.one` is _exactly_ the same as `M['one']`.

## Types of Value

The standard function `type` returns the type of any Lua value...

### `nil`

`nil` is a special case; other languages call it `NULL`, `nil`,`Nothing`,`null`,etc.
It is however a valid value and has a definite type, which is 'nil'.

Only `nil` and the boolean `false` values make conditions fail.

Otherwise, `nil` is special when used with tables; table elements cannot be `nil`.

Be particularly careful when putting `nil` values into an array; these will become
'holes' and the value of `#arr` will become invalid.

### Numbers

Lua has only one type of number, which is usually double-precision floating-point on
desktop machines. This means you do not usually have to worry about integers and
floats;  this is one of the simplifications which makes Lua so small and fast. If
you worry about storing integers as double-precision floats, remember that integers
can be _exactly_ represented up to about 1e16.

There are two rounding functions, `math.floor` and `math.ceil`; so given 3.1, the
first gives the integer part (3), and the second gives the first integer that is
larger (4). `math.ceil(x)==x` is only true if `x` is an integer.

Remember that 0 does not fail a condition, unlike C or Python.

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

The `tonumber` function will explicitly convert a string to a number; it will return
`nil` if the conversion is not possible.  It can also be used to convert hexadecimal
numbers like so:

    val = tonumber('FF',16) -- result is 255

How about converting numbers to strings? `tostring` does the general job of
converting any Lua value into a string. (The `print` function calls `tostring` on
its arguments.)  If you want more control, then use the `string.format` function:

    string.format('%5.2f',math.pi) == ' 3.14'

These `%` format specifiers will be familiar to C and Python programmers, but basic
usage is straightforward: the 'f' specifier has a total field with (5) and a number
of decimal places (2) and gives fixed floating-point format; the 'e' specifier gives
scientific notation. 's' is a string, 'd' is an integer, and 'x' is for outputing
numbers in hex format.

There is a set of standard operations on strings. We saw that 'adding' strings would
try to treat them as numbers. To join strings together (_concatenate_) there is the
`..` operator:

    "1".."2" == "12"

Most languages use `+` to mean this, so note the difference. Using a different
operator makes it clear, for instance, that `1 .. 2` results in the _string_ '12'.

As with arrays, `#s` is the length of the string `s`.

The opposite operation is extracting substrings.

    string.sub("hello",1,4) == "hell"
    string.sub("hello",4) == "lo"

The first number is the start index (starting at _one_, as with arrays) and the
second number is the final index; the result includes the last index, so that
`sub(s,1,1)` gives the first 'character' in the string:

    -- printing out the characters of a string
    for i = 1,#s do
       print(string.sub(s,i,i))
    end

It is not possible to treat a string as an array - `s[i]` is not meaningful. (It
will just silently return `nil`)  A Lua string is not a sequence of characters, but
a read-only lump of bytes; it is not very efficient to process a string by iterating
over its bytes and in fact Lua provides much more powerful techniques for string
manipulation.

For instance, a naive solution to the problem of finding a character in a string
involves looking at one character at a time; the `string.find` function is faster
and less trouble.

    string.find('hello','e') == 2

In general, this function will return _two_ values, the index of the start and the
finish of the matched substring:

    print(string.find('hello','lo'))
    --> 4       5

(Which are exactly the numbers you need to feed to `string.sub`.)

This may not seem so very useful, because we knew the length of the substring.
However, `string.find` is much more powerful than a simple string matcher.

In general, the 'substring' is a Lua string pattern. If you have previously met
regular expressions, then string patterns will seem familiar. For instance, the
string pattern 'l+' means 'one or more' repetitions of 'l'.

    print(string.find('hello','l+'))
    --> 3       4

[digits,letters,..captures? Need to keep this over...]

'Character classes' make string patterns much more powerful. The pattern '[a-z]+'
means 'one or more letter in the range 'a' to 'z':


    print(string.find('hello','[a-z]+'))
    --> 1       5

That is, it matches the whole string. So we could write a function `is_lower` like so:

    function is_lower(s)
        i1,i2 = string.find(s,'[a-z]+')
        return i1 == 1 and i2 == #s
    end

But there is a neater way. The pattern '^[a-z]+$' does the job, since it says that
the sequence of one or more letters must start at the begining ('^') and end at the
finish ('$'). So `string.find` will return `nil` for ' hello'.

Lua provides names for common character classes; '%a' is short for '[a-zA-Z]' and
'%d' is short for '[0-9]'. '%s' stands for any whitespace, i.e. '[ \t\r\n]'. The
capital letter versions stand for any characters _not_ in the set, so '%S' stands
for anything that is not a space. So the pattern '^%S+$' will match any sequence of
characters that does not contain a space. (These are different from the usual
regular expression syntax, which is to use a backslash. So Lua patterns tend to be
easier to read than regular expressions. However, they are more limited.)

String patterns are an important part of learning Lua well, and we will return to
them in this Cookbook. But you should always be aware of them, because `string.find`
normally assumes that the match is a pattern that contains 'magic' characters.  For
instance, '$' stands for 'end of string'; if you wanted to find an actual '$' in a
string then you have two options:

  * _escape_ the magic character like so: '%$'
  * use `string.find(s,sub,1,true)`; the last argument means 'plain match'.

A very powerful function for modifying strings is `string.gsub` (for _global
substitute_):

    print(string.gsub('hello help','e','a'))
    --> hallo halp     2

It replaces _each_ match of the pattern with a given string, and returns the
resulting string and the number of substitutions.  There can also be a fourth
argument which lets you set the maximum number of substitutions:


    print(string.gsub('hello help','e','a',1))
    --> hallo help      1

(There is no form that does a 'plain match' like `string.find` so you will have to
be careful to escape magic characters.)


### Tables

We have encountered tables used as arrays and as maps. The best way of seeing a Lua
table is that it is an associative array that can have any kind of key, including
numbers. It is very efficient at _behaving_ like an array, that is, consecutive
integer keys starting at one.

Here is a more general table:

    T = {10,20,30,40,50; sorted=true}

Here `T[i]` for `i` from 1 to 5 is the array (#T is 5, _not_ 6!) and `T['sorted']`
is the map. So it is commonly said that a Lua table has both an array and a map part
. It is more correct to say that it can be used both ways.

Most of the `table` functions are meant to operate on arrays; you can sort them with
`table.sort`. In the simple case the table must only contain numbers (or sortable
objects), but a sort function can be provided.

Arrays of strings can be joined together with `table.concat`. This is the most
efficient way to build up large strings:

    local res = {}
    for i = 1,1000 do
        res[i] = "hello "..i
    end
    str = table.concat(res)

(Note that `table.concat` is picky about the array elements; they must either be
numbers or strings. If in doubt, use `tostring` to convert values first.)

The most commonly used function with tables is `pairs` which allows you to iterate
over all the elements.  There is a corresponding function `ipairs` which works for
arrays:

    for i,v in ipairs{10,20,30; x=1} do print(i,v) end
    --> 1   10
    --> 2   20
    --> 3   30

Unlike `pairs`, `ipairs` will give you the keys in the correct order, and it will
only access the array part.

(Notice that you can say `ipairs{...}`. There are two cases when Lua does not need
extra parentheses when calling a function; if the function is being passed one
argument and that argument is either a string or a table constructor.)

### Functions

A Lua function is also a value; you can assign it to a variable, pass it to another
function.

Consider this table of data objects:

    T = {{a=1},{a=3},{a=2}}

This can be sorted using `table.sort` with a custom sort function:

    table.sort(T,function(x,y) return x.a < y.a end)

This is called an 'anonymous function', since it has not been given a name. Although
in a real sense, all Lua functions are anonymous.

The usual definition of a function:

    function answer()
        return 42
    end

is exactly equivalent to this assignment:

    answer = function()
        return 42
    end

This is a useful way to look at Lua programs, since then it's clear that _executing_
the function definition makes the function available. Consider this Lua file:


    -- main.lua
    main()

    function main()
        print ('hello, world')
    end

It will crash, complaining that it is trying to call a `nil` value. The variable
`main` has not been defined yet, which is easy to see if you write the function
definition as `main = function()...`.

A very interesting feature of Lua functions is that they may return _multiple values_:

    function multiple()
        return "hello",42
    end

    name,age = multiple()

If know Python, then you may think that `multiple` returns a 'tuple', which the
assignment then helpfully unpacks, but the reality is simpler and weirder: this
function genuinely returns two values. This is useful because Lua functions can very
efficiently return a set of values without having to pack them into a table.

Multiple return values are handled specially if they are returned by the _last_
expression in a function argument list or table constructor:

    > print('?',multiple())
    ?   hello    42
    > t = {'?',multiple()}
    > print(t[1],t[2],t[3])
    ?   hello    42

This is sometimes not what you want; it is always possible to select only the first
value returned by enclosing the call in parentheses, like `(multiple())`.

Some standard library functions, like `string.find`, naturally return multiple
values. Others usually return a single value, but return `nil` and an error message
if something goes wrong. Consider opening a file for reading:

    f,err = io.open('test.dat')
    if not f then print(err)
    else
      ...
    end

The standard function `unpack` will take a table and turn it into multiple
expressions; note again how `print` deals with these.

    print(unpack({10,20,30})
    --> 10    20   30

Functions are values, and so functions can return functions.

    function adder(x)
        return function(y) return x + y end
    end

    a = adder(1)
    b = adder(10)
    print(a(2))  --  3 (= 1 + 2)
    print(b(3))  -- 13 ( = 10 + 3)

Apart from it appearing strange to see an anonymous function used like that, this is
really a most interesting result.  How does function `a` remember that `x` was 1?
The answer is that every time `adder` is called, it makes a new function. And that
new function contains its own hidden variable that is initialized to the argument
`x`.  This hidden variable is called an 'upvalue' and the resulting function called
a 'closure'. It might seem that creating new functions is expensive, but this is not
so; all these new functions share the same bytecode but have their own separate
upvalues.

Here is another example of a closure - a 'function with memory'

    function counter()
        local count = 0
        return function()
            count = count + 1
            return count
        end
    end

    c = counter()
    for i = 1,5 do
        print(c())
    end

We could use `counter` to create lots of these functions, and they would all have
their copy of `count`.  (Note that it is important that `count` was a local variable
inside `counter`, because otherwise it would have just been a global reference
shared by all the functions.)

The function `pairs` is said to return an iterator. What animal is this? In its
simpler form, an iterator is just a function of no arguments which returns different
values each time, exactly like these counter functions. Usually, iterators know when
to stop, which they do by returning `nil`.

    function iter(t)
        local i = 0
        return function()
            i = i + 1
            return t[i]
        end
    end

    for v in iter {10,20,30} do print(v) end
    --> 10
    --> 20
    --> 30


### Coroutines

Although coroutines are sometimes called threads (and `type` returns 'thread' as
their type) they are not operating system threads as usually understood. (Lua
sometimes runs on machines that don't even have the luxury of an operating system.)

Rather, a coroutine is another kind of 'function with memory'. Once a coroutine is
created from a regular Lua function, it can be resumed; the coroutine yields and
waits for the caller to resume it again. Unlike a function which is repeatedly
called, it resumes exactly at the point where it last yielded.

    function coco()
        print '1'
        coroutine.yield(1)
        print '2'
        coroutine.yield(2)
        print '3'
        coroutine.yield(3)
    end

    c = coroutine.create(coco)
    print(coroutine.resume(c))
    print(coroutine.resume(c))
    print(coroutine.resume(c))

    ----> output:
    1
    true	1
    2
    true	2
    3
    true	3

The first `resume` call causes the first `yield` call (after printing 1) and we get
the value that was passed to `yield`. The second `resume` call makes the `yield`
return and we print out 2, etc.

So each coroutine preserves its complete state, and is sleeping when not explicitly
resumed. This is often called 'cooperative multitasking' because one coroutine has
to yield for another coroutine to resume.

## Programs

### Scope of Variables

There are two kinds of variables in Lua, local and global. Globals are visible
throughout the whole program, and local variables are only visible in the block
where they have been declared. Good programming practice is to keep the number of
globals down.

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
B1 and `k` is visible up to the end of block B2. In particular, it is not defined in
`print(k)`!

If a variable is undefined - that is, not local - then it's assumed to be global.

### Errors

### Modules



