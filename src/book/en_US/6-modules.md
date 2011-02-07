## Modules

The global function `dofile` will evaluate a Lua file. However, it is not very useful
for organizing libraries and large programs. It takes a full path to the Lua file,
which is a problem for programs that need to be portable, and it will always load
the source file each time.

`require` solves these problems by looking for
the Lua file in standard locations, and only loading it once.

`require` is given a _module name_, without an extension. To understand how the
modules are found, it is useful to look at the error message you get when a module
is _not_ found:

    require 'alice'
    ---> a Linux machine
    lua: module 'alice' not found:
        no field package.preload['alice']
        no file './alice.lua'
        no file '/usr/local/share/lua/5.1/alice.lua'
        no file '/usr/local/share/lua/5.1/alice/init.lua'
        no file './alice.so'
        no file '/usr/local/lib/lua/5.1/alice.so'
        no file '/usr/local/lib/lua/5.1/loadall.so'
    --> a Windows machine
    lua: module 'alice' not found:
        no field package.preload['alice']
        no file '.\alice.lua'
        no file 'C:\Program Files\Lua\5.1\lua\alice.lua'
        no file 'C:\Program Files\Lua\5.1\lua\alice\init.lua'
        no file 'C:\Program Files\Lua\5.1\alice.lua'
        no file 'C:\Program Files\Lua\5.1\alice\init.lua'
        no file 'C:\Program Files\Lua\5.1\lua\alice.luac'
        no file '.\alice.dll'
        no file '.\alice51.dll'
        no file 'C:\Program Files\Lua\5.1\alice.dll'
        no file 'C:\Program Files\Lua\5.1\clibs\alice.dll'
        no file 'C:\Program Files\Lua\5.1\loadall.dll'
        no file 'C:\Program Files\Lua\5.1\clibs\loadall.dll'

The first place where `require` looks is the current directory; if there was a file
`alice.lua` in the same directory as this program, it would be loaded. Then it will
look in a few standard places - for Unix this is usually the directory
`/usr/local/share/lua/5.1` and for Lua for Windows it is the `lua` subdirectory
of the installation directory.

Then things get interesting; it starts looking for
`.so` files on Unix and `.dll` files on Windows - these are _binary Lua extensions_
which are shared libraries, usually written in C. So `require` will load both pure
Lua and binary modules.

How does Lua know which locations to search? The system variable `package.path`
contains the locations where Lua modules will be found. it is a string containing
_patterns_ separated by semi-colons: (I've printed these patterns on separate lines
for clarity)

    print(package.path)
    -->
    ./?.lua;
    /usr/local/share/lua/5.1/?.lua;
    /usr/local/share/lua/5.1/?/init.lua;

The procedure to find module `alice` is simple; take each of these patterns, and
replace `?` with 'alice'; if the result is an existing file, load it.

(Remember that Lua has _no_ built-in concept of a file system; this search is done by
string substitution followed by an attempt to open the result.)

If this search fails, then Lua will use `package.cpath` to find a binary extension
in a similar way.  So you can see that the error message is detailing exactly what
happens in this process.

So, to summarize, `require`:

  * takes a module name, not a file name
  * looks for both Lua files and shared libraries (binary extensions)
  * only loads the module once
  * looks on the Lua and extension paths

A simple way to try this out is to create a Lua file `mod1.lua`:

    -- mod1.lua
    print("hello")

and require it from `usemod1.lua`, in the same directory:

    -- usemod1.lua
    require("mod1")
    print("dolly")
    -->
    hello
    dolly

Which shows that the file loaded by `require` can be any Lua code. Actually, the
word 'module' is just a word we use to describe Lua files that are generally
useful for different programs to use - there is no formal concept of 'module' in
the language itself.

Modules are usually used to make functions and data available to a
program.  It is better to put these into their own table:

    -- mod2.lua
    mod2 = {}
    mod2.answer = function()
        return 42
    end

Now, after `require("mod2")` our code can call `mod2.answer()`. There can now be
a number of functions called `answer` in the program and they will not interfere
with each other.

If you move `mod2.lua` to a location on your Lua path (such as
 '/usr/local/share/lua/5.1/') then a Lua program anywhere on the system can load
the module `mod2`.

Of course, to copy files into the system-wide directory often requires superuser
privileges. These standard directories are built into Lua and may not be
convenient for your purposes.

You can add other directories to the Lua module path by setting the
environment variable `LUA_PATH`. For a Bash shell on Unix this would look like:

    export LUA_PATH=";;/home/steve/lualibs/?.lua"

On Windows:

    set LUA_PATH=;;c:\lua\lualibs\?.lua

Please note that the semi-colon is used to separate patterns on all systems. The double
semicolon at the start means "append this to the existing Lua module path" so Lua will
first look in the system-wide directory for modules.

So, there is nothing special about a Lua file loaded by `require`. Generally, it should
create a table containing the functions. A common pattern looks like this:

    -- mod3.lua
    local mod3 = {}

    function mod3.fun1()
      return 42
    end

    function mod3.fun2()
      return mod3.fun1()
    end

    return mod3

Note that it _returns the table_.  A user of the module may now say:

    local mod3 = require 'mod3'

This way of writing modules does not create a global table. Consider the effect of
leaving out the `local` when declaring `mod3`: then the table _is_ available globally.
You can then use it like follows:

    require 'mod3'
    print(mod3.fun1())

It's _always_ a good idea to return the value of a module. If you do not, then
`require` simply returns `true`, which is not very useful. Lua programmers expect
`require` to return a table containing the functions.

Please note that functions in a module may depend on each other, but they must
reference them using the table explicitly.

Using global tables of functions is going out of fashion in the Lua world, because
it leads to the problems discussed in the section on variables and scope. Particularly
in a big program, the aim is to keep the number of globals floating around to the
absolute minimum.

There is a common style introduced in Lua 5.1 for creating modules, which
many libraries use. The `module` function creates a named table of functions and
sets the environment of the file so that these functions may be declared and without
explicit reference to the table:

    -- mod4.lua
    module("mod4")

    function fun1()
      return 42
    end

    function fun2()
      return fun1()
    end

This has the same affect as `mod3` without the `local` declaration; `require` returns
the table, and a global variable `mod4` is created which refers to the table.

It is convenient that the module functions can call each other directly, but there
is a tricky little issue:

    -- mod5.lua
    module("mod5")

    function dump(msg)
      print(msg)
    end

Calling `mod5.dump` leads to a run-time error:

    .\mod5.lua:5: attempt to call global 'print' (a nil value)
    stack traceback:
            .\mod5.lua:5: in function 'dump'
    ...

This is because we are not inside the global environment, but inside the environment
created by `module`. The recommended fix is to insert the following line _before_
the call to `module`:

    local print = print

The other fix is to make the module call look like this:

    module("mod5",package.seeall)

This makes all the global functions available to the module. It's beter however
to define what you need explicitly at the top of the module, since then readers
can see at a glance what the dependencies are. (Last, but not least, using locals
is significantly faster.)
