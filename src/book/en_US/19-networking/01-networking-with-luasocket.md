# Networking with LuaSocket

Author: Matthew Frazier <leafstormrush@gmail.com>

The most common library for networking in Lua is
[LuaSocket](http://w3.impa.br/~diego/software/luasocket/) by Diego
Nehab. In addition to low-level support for communicating directly
through sockets, it also includes:

-   HTTP client
-   FTP client
-   SMTP client
-   Mail processing filters
-   URL manipulating functions

LuaSocket is installable via LuaRocks, as explained in
:ref:\`luarocks\`. Many distributions also provide LuaSocket
packages.

\TODO Fix references

## Socket-Level Programming

To create a TCP socket [^1] connected to a particular place, you
can use `socket.connect`, like this:

    require 'socket'
    local sock = socket.connect("www.example.com", 80)

From there, you can send and receive on the socket object.

    sock:send("GET / HTTP/1.0\n\n")
    local data = sock:recv()

You could also use `socket.tcp("www.example.com", 80)` and then
`connect` it separately, but this is a shortcut.

[^1]: There's also UDP, but we're not covering it in this introduction.

## Servers

Servers are *cool!* According to some guy we met:

> Servers are the whole reason the Internet exists as we know it.

You can create servers by using `socket.bind`.

Here is a graph about servers.

![image](server-graph.jpg)

### Concurrency

Everyone is talking about concurrency these days!

Some of the ways people have thought of for being concurrent are:

1.  Multithreading.
2.  Having multiple processes.
3.  Asynchronous programming.

Fortunately, Lua has something cool you can use for number three:
Coroutines! (If you don't know about coroutines, see
:ref:\`using-coroutines\` for more info.)

## Glossary

client
  ~ The program run by the user that talks to clients.

server
  ~ The program that clients talk to.

TCP
  ~ What most people use nowadays instead of UDP.
