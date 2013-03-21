## Strings

The `tonumber` function will explicitly convert a string to a number; it will return
`nil` if the conversion is not possible.  It can also be used to convert hexadecimal
numbers like so:

    val = tonumber('FF',16) -- result is 255

How about converting numbers to strings? `tostring` does the general job of
converting any Lua value into a string. (The `print` function calls `tostring` on
its arguments.)  If you want more control, then use the `string.format` function:

    string.format("%5.2f",math.pi) == '"3.14"

These `%` format specifiers will be familiar to C and Python programmers, but basic
usage is straightforward: the 'f' specifier has a total field with (5) and a number
of decimal places (2) and gives fixed floating-point format; the 'e' specifier gives
scientific notation. 's' is a string, 'd' is an integer, and 'x' is for outputing
numbers in hex format.

    print(string.format("The answer to the %s is %d", "universe", 42) )
    -->
    The answer to the universe is 42

There is a set of standard operations on strings. We saw that 'adding' strings would
try to treat them as numbers. To join strings together (_concatenate_) there is the
`..` operator:

    "1".."2" == "12"

Most languages use `+` to mean this, so note the difference. Using a different
operator makes it clear that `1 .. 2` results in the _string_ "12" and not
the _number_ `3`

As with arrays, `#s` is the length of the string `s`. (This is the number of _bytes_, not the
number of characters.)

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

`string.match` is similar to `string.find`, except that it does not return the
index range, but rather the match itself.

    print(string.match('hello dolly','%a+'))
    --->
    hello

Here the pattern means 'one or more alphabetic characters', so the match gives
us the first word.  You could do this with a combination of `string.find` and
`string.sub`, but `string.match` is more general and efficient. Consider:

    print(string.match('hello dolly','(%a+)%s+(%a+)'))
    --->
    hello     dolly

Here `match` returns _two_ matches, which are indicated using parentheses
in the string pattern. These are often called _captures_.  So the pattern
would read like  this 'capture some letters, skip some space, and capture
some more letters'.

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

Finally, there is `string.gmatch` which iterates over all the matches in a string.
A common task is finding all the words in a string, separated by spaces. The
pattern '%S+' means 'one or more non-space character', but `string.match` will
only give you a fixed number of matches.

    local str = 'one  two   three'
    for s in string.gmatch(str,'%S+') do
        print('"'..s..'"')
    end
    -->
    "one"
    "two"
    "three"

This suggests the following useful function, which breaks up a string into a
table of words:

    function split(str)
        local t = {}
        for s in string.gmatch(str.'%S+') do
            t]#+1] = s
        end
        return t
    end

To split a string with other delimiters is just a matter of choosing the right
pattern. For instance, '[%S,]+' matches
'one or more characters from the set of non-space and comma'. You could
use this to split 'one, two, three' into `{'one','two','three'}`.

The special pattern '.' matches _one_ arbitrary byte. So

    for c in string.gmatch('.') do print(string.byte(c)) end

prints all the byte codes in a string.

