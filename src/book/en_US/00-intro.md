# An Introduction to Lua

This introduction assumes that you have some familiarity with basic programming.

We recommend that you get a good programmer's editor which understands Lua syntax
and can highlight it appropriately. This is not just because it's more attractive,
but such an editor can immediately show you common mistakes like forgetting the
closing quote on a string.  Such editors can also match up parentheses and braces.
They will often automatically _indent_ code for you, which is important for
readability..

It is better to lay out code like this:

    for i = 1,10 do
        if i < 5 then
            print("lower",i)
        else
            print("upper",i)
        end
    end

Than this:

    for i = 1,10 do
    if i < 5 then
    print("lower",i) else
    print("upper",i)
    end
    end

The logical structure of the code is now harder to see. By making indenting a habit,
you will write code that will be more readable to another person. (After several
months, you will be that other person.)

A good start is the Lua [wiki](http://lua-users.org/wiki/LuaEditorSupport). If you
are on Windows, then the Lua for WIndows distribution comes with SciTE, which also
has Lua debugging support.

## Basics

### Expressions

It is traditional to start with "Hello, world". Like all scripting languages, this
is straightforward:

    print("Hello world")

An important point is that `print` is a function which takes a number of values and
prints out these values to standard output. It is not a statement, as in Python 2.X
or Basic.

To run this example, save this line as 'hello.lua' and run from the command line:

    $> lua hello.lua
    Hello world!

(Or, use an editor that knows how to run Lua, like SciTE in Lua for Windows. The F5 key
will run the current program.)

Arithmetic expressions use standard programming notation:

    print("result",2 + 3 * 4 ^ 2)

There is an exponentiation ('power of') operator `^`, unlike in C or Java.

The order of evaluation follows the usual rules, and you can use parentheses to group
expressions - for example, `(1 + 2)*(3 + 4)`.  The original expression could be written like:

    (2 + (3 * (4 ^ 2))

which makes the order obvious. When in doubt, use parentheses, but knowing when you
have to use them is an important part of learning a programming language.

Operations like `+` and `*` are called _operators_, and the values they operate on are
called _arguments_.

There is a remainder operator, `%` which gives the integer remainder from a division:

    print(1 % 2) --> 1
    print(2 % 2)  --> 0
    print(3 % 2) --> 1

 There are the usual
standard mathematical functions available in the `math` namespace (or _table_) like
`math.sin`, `math.sqrt`,etc. The useful constant `math.pi` is also available.

    print('sin', math.sin(0.5*math.pi), 'cos', math.cos(0.5*math.pi))

This is more readable when spread over two lines using a _variable_ `x`:

    x = 0.5*math.pi
    print('sin',math.sin(x),'cos',math.sin(x))

Of course, you could say that `x` is not a variable, but Lua does not make any
distinction between variables and named constants.

Even if the command-line is not your strong point, I recommend learning Lua interactively.

    $> lua
    Lua 5.1.4  Copyright (C) 1994-2008 Lua.org, PUC-Rio
    > print(10 + 20)
    30
    > = 10 + 20
    30
    > = math.sin(2.3)
    0.74570521217672
    > p = math.pi
    > = math.cos(p)
    -1

Starting a line with `=` is a shortcut for `print()`.  Interactive Lua is a very
useful scientific calculator !

With Lua for Windows, it is not even necessary to open a command prompt. On the
SciTE toolbar, there is a prompt icon with the tooltip 'Launch Interactive Lua'. It will open
an interactive session in the output pane, and you can evaluate Lua statements. As with
a console prompt, the up and down arrows can be used to select and re-evaluate
previous statements.


### Variables and Assignment

Lua variables may have letters, digits and underscores ('_'), but they cannot start with
a digit. So `check_number`, `checkNumber`, and `catch21` are fine, but `21catch`
is not. There is no limit to the length of variable names, except the patience of you
and your readers.

Variables are _case-sensitive_.  `ERROR`,`Error` and `error` are all different variables.

They may contain any Lua type:

    x = "hello"
    x = 1
    x = x + 1

Here, the value of `x` becomes "hello", and then it becomes 1, and finally 2 (which
is the value of `x + 1`).  This process is commonly called _assignment_.

Variables have no fixed type, but always contain a definite type of value,
even if it is just `nil`.

Assigning multiple variables works like this:

    x, y = 1, 2

This sets `x` to 1 and `y` to 2. This is different from the usual `x=1, y=2` style in
other languages. It is possible to swap the values of two variables in one line:

    x, y = y, x

The _assignment_ statement `x = 1` is not an expression - it does not return a value.

### Numeric `for` loops

Programming is more than calculation. The simplest way to do something a number of
times is the _numeric for_ statement:

    for i = 1, 5 do
        print("hello",i)
    end
    -->
    hello   1
    hello   2
    hello   3
    hello   4
    hello   5

Any statements in the _block_ from `do` to `end` are repeated with different values
of the variable `i`.

Spacing and line ends (often called 'whitespace') is usually not important. This
code could also be written like so:

    for i = 1, 5 do print("hello", i) end

or

    for i = 1, 5
    do
    print("hello",i)
    end

However, the last example would be considered bad style. The logic of a program is
much easier to follow if statements are laid out at the right columns.

The numeric `for` statement loops from a start to a final value, inclusive. There can be a
third number, which is the 'step' used in calculating the next value.  To print the
greetings out backwards:

    for i = 5, 1, -1 do print("hello",  i) end

So to print a little table of sine values from 0 to &pi; with steps of 0.1:

    for x = 0, math.pi, 0.1 do
        print(x, math.sin(x))
    end

@ note [
There is something you need to know about `for` variables; they only exist inside
the block.

    for i = 1,10 do print(i) end
    print(i)

You might expect that the last value printed would be 11, but the last `print` will
show just `nil`; `i` is _not defined_ outside the loop.
]

### Conditions

Programs often have to make choices.

    age = 40
    if age > 30 then
       print("too old to play games!")
    end

(Well, that's rude, but computers often are. You can't please everyone.)

The expression in the `if` statement is called a _condition_. For instance,
`10 == 10` is always `true`; `2 >= 3` (meaning 'greater or equal') is always `false`.

Like Python and the C-like languages `==` is used for 'is equal', since a single `=`
has a very different meaning. Unlike them, 'not equal' is `~=` (the tilde `~` is
usually the key on the far left side, next to `!`)

It is common to have two different actions based on the condition:

    if age > 30 then
        print("still too old")
    else
        print("hello, kiddy!")
    end

And there may be multiple choices:

    age = 18
    if age == 18 then
        print("just right")
    else
        if age > 30 then
            print("too old")
        else
            print("too young")
        end
    end

This style gets irritating  if there are more than two conditions.
`if-else` statements can be combined together using the single word
`elseif` (not the two words `else if`!)

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

The `not` operator turns `true` into `false`, and vice versa. Instead of saying `age > 30`
you can say `not(age <= 30)`. The parenthesis is needed here because `not` has a
higher precedence than `<=`; in fact it has the highest precedence of the logical
operators.

Lua will 'short-circuit' logical expressions, For example,

    if type(n) == 'number' and n > 0 then .... end

`n > 0` will give an error if `n` is not a number, but Lua knows that if the first argument
of `and` is `false`, then there is no point in evaluating the second argument.

In general,
if a condition is `f() and g()`, then if the result of calling `f` is `false` there is no need to
call `g`. Simulary, in `f() or g()` Lua will not call `g` if `f` returns `true`.

`and` and `or` in Lua do not only return `true` or `false`.  `and` always returns its
second argument if both arguments pass, or the argument that does not pass.
(Only `nil` and `false` fail a condition.)

    print (10 and "hello") --> hello
    print (false and 42) --> false
    print (42 and false) --> false
    print(nil and 1) --> nil

`or` will return the argument that succeeds (i.e not `nil` or `false`)

    print (10 or "hello") --> 10
    print(false or 42)  --> 42

This leads to some common shortcuts in Lua code. For example,  this explicit statement
for setting a default value:

    if x == nil then
        x = 'default'
    end

is often written like this:

    x = x or 'default'

A common pattern for choosing one of two values looks like this:

    a = 2
    print(a > 0 and 'positive' or 'zero or negative')  -- positive

`if` statements can be used inside the `for` statement:

    for i = 1,10 do
        if i < 5 then
            print("lower",i)
        else
            print("upper",i)
        end
    end

Generally any statement can be 'nested' inside any other statement.

### Conditional Loops

This produces the same output as the simple `for` statement example:

    i = 1
    while i < 5 do
        print("hello",i)
        i = i + 1
    end

The body of the `while` loop is repeatedly executed _while_ a condition is true;
each time one is added to the variable `i` , until it becomes 6, and the condition fails.

The other loop statement is `repeat`, where we loop _until_ a value is true.

    i = 1
    repeat
        print("hello",i)
        i = i + 1
    until i > 5

For these simple tasks, it is better to use a `for` statement, but the condition in these loops
can be more complex.

### Tables

Often we need to store a number of values in order, usually called arrays or lists.

Arrays in Lua are done using _tables_, which is a very general data structure. A
simple array is easy to define:

    arr = {10,20,30,40}

and then the first element will be `arr[1]`, etc; the length of the array is `#arr`.
So to print out this array:

    for i = 1, #arr do print(arr[i]) end

Arrays start with index 1; it's best to accept this and learn to live with the
fact.

These arrays are resizable; we can add new elements:

    arr[#arr + 1] = 50

and insert elements at some position using the standard function `table.insert`; the
second argument is the index _before_ where the value is inserted.

    table.insert(arr, 1, 5)

After these two operations the array now looks like `{5,10,20,30,50,50}`.

Arrays can be constructed efficiently using a for-loop. This creates an array containing
the squares of the first ten integers:

    arr = {}  -- an empty table
    for i = 1, 10 do
        arr[i] = i ^ 2
    end

Please notice that it is not necessary to specify the size of the array up front; a table
will automatically increase in size.

To complete the picture, there is `table.remove` which removes a value at a given
index.

The function `table.sort` will sort an array of numbers in ascending order.

Lua tables can contain any valid Lua value:

    t = {10,'hello',{1,2}}

So `t[1]` is a number, `t[2]` is a string, and `t[3]` is itself another table. (But do not
expect `table.sort` to know what to do with `t` !)

What about trying to access an element that does not exist, e.g. `arr[20]`? It
will not raise an error, but return the value `nil`.  So it is wise to carefully
check what is returned from an arbitrary tab;e access.  Since `nil` always indicates
'not found', it follows that you should not put `nil` into an array.  Consider:

    arr = {1,2,nil,3,4}

What is `#arr`? It may be 2, but it will definitely not be 5. In other words,
it is undefined. Since inserting `nil` into an array causes such a
breakdown of expected behavior, it is also called 'inserting a hole'.

The same caution applies to creating arrays that start at 0.

    arr = {}
    for i = 0,9 do arr[i] = i end

Well, `arr[0]` will be 0, and `arr[9]` will be 9, as expected. But `#arr` will be 9, not 10.
And `table.sort` will only operate on indexes between 1 and 9.  (So yes, it is possible
to arrange arrays from 0, but the standard table functions will not work as expected.)

It is possible to compare tables for equality, as we did above:

    a1 = {10,20}
    a2 = {10,20}
    print(a1 == a2) --> false !

The result is `false` because `a1` and `a2` are different _objects_. Table
comparison does not compare the elements, it just checks whether the arguments are
in fact the same tables.

    a1 = {10,20}
    a2 = a1
    print(a1 == a2) --> true !
    a1[2] = 2
    print(a2[2]) --> 2

`a1` and `a2` are merely names for the same thing - `a2` is just an _alias_ for `a1`.

Newcomers to Lua are often surprised by the lack of 'obvious' functionality, like
how to compare arrays 'properly' or how to print out an array. It helps to think of
Lua as 'the C of dynamic languages' - lean and mean. It gives you a powerful core
and you either build what you need, or reuse what others have provided, just as with
C.  The whole purpose of the Lua cookbook is to provide good solutions so you do
not have to reinvent the wheel.

There is another use of Lua tables, constructing 'dictionaries' or 'maps'.  Generally a
Lua table associates values called  'keys' with other values:

    M = {one=1,two=2,three=3}

`M` operates like an array with string indexes, so that we have:

    print(M['one'],M['two'],M['three'])
    --> 1   2   3

An unknown key always maps to `nil`, without causing an error.

To iterate over all the keys and values requires the generic `for` loop:

    for key, value in pairs(M) do print(key, value) end
    --> one     1
    --> three   3
    --> two     2

The `pairs` function creates an _iterator_ over the map key/value pairs which the
generic `for` loops over.

This example illustrates an important point; the _actual_ order of iteration is not
the _original_ order.  (In fact the original order is lost, and extra information
needs to be stored if you want the keys in a particular order.)

### Functions

It is straightforward to create your own functions. Here is a sine function which
works in degrees, not radians, using the standard function `math.rad` for converting
degrees to radians:

    function sin(x)
        return math.sin(math.rad(x))
    end

That is, after the keyword `function` there is the function name, an _argument list_
and a group of statements ending with `end`. The keyword `return` takes an
expression and makes it the value returned by the function.

Functions are the building blocks of programs; any programmer collects useful functions
like cooks collect tasty recipes.  Lua does not provide a standard function to print
out arrays, but it is easy to write one:

    function dump(t)
        for i = 1, #t do
            print( t[ i ] )
        end
    end

A function does not _have_ to return a value; in this case we are not interested in the
result, but the action.

This `dump` is not so good for longer arrays, since each value is on its own line. The
standard function `io.write` writes out text without a line feed:

    function dumpline (t)
        for i = 1, #t do
            io.write( t [ i ] )
            if i < #t then io.write( "," ) end
        end
        print()
    end

    dumpline({10,20,30})
    --->
    10,20,30

True to its name, most of this Cookbook is dedicated to giving you functions to do
useful things.

