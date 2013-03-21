## Programs

Lua is often called a 'scripting langauge' which implies that it is only suitable
for bashing out little scripts to do specific tasks. This is not true; many
commercial games have much of their functionality written in Lua, as do other products
like Adobe Lightroom.  It has always been the fastest of the dynamic languages,
typically several times faster than Python or Ruby, and the LuaJIT just-in-time
compiler can give performance equivalent to conventional compiled languages.

However, there are certain habits that are essential in writing robust Lua code
which can be safely used to build large applications. The difference between a
'script' and a 'program' is fairly arbitrary. A script is often defined as
a small program that does a specific task for knowledgeable users.
Compilation does not magically transform a script into a
program, however the built-in discipline of statically-typed languages helps to
debug faults before actually running them. Everything is declared, and everything
has a definite type.  With a dynamically-typed language, you have to provide that
discipline.

For example, a script can use only global variables, and work fine. But experience
shows that you will enter a zone of frustrating debugging if you write non-trivial
applications in this way.

Lua is in fact compiled before it executes, although usually the generated
_bytecode_ is not saved, since the compiler is so fast as to be practically
instantaneous on everything except the largest programs. This means that syntax
errors (like forgetting to say `then` after `if`) will be caught immediately.

However, these are easy errors to avoid and you will find yourself making fewer
with time, since Lua has a simple syntax and there are not too many rules to
remember. But misspelling variables is not a compiler error, and not a run-time
error either, as we will see.

For a larger application, it is important to spread it out over multiple files.
So it is important to know how to build and use libraries of dependable code. By
knowing what libraries are available in the Lua universe, you can avoid re-inventing
wheels and get on with building the car.

!extend...!
