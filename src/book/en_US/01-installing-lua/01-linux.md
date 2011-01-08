Installing Lua on Linux
=======================

Author: Alexander Gladysh <agladysh@gmail.com>

\WARNING Stub article

Installing from source
----------------------

You'll need `libreadline`.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~[ console ]~~
$ wget http://www.lua.org/ftp/lua-5.1.4.tar.gz
$ tar -zxf lua-5.1.4.tar.gz
$ cd lua-5.1.4.tar.gz
$ make linux
$ sudo make install
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

\TODO Check this

Ubuntu
------

To install Lua on Ubuntu:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~[ console ]~~
$ sudo apt-get install lua
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

\TODO Note about LuaRocks incompatibilities (if any).

\TODO Add more Linux flavors here.
