### Metatables

Any table or userdata may have a _metatable_ associated with it.  Metatables specify
the behaviour of their tables, in a similar way to how classes specify the behaviour of
their objects in a traditional object-orientated language.  Metatables do this by defining
_metamethods_.  In other respects, metatables are plain tables.


`tostring` will try to convert a value into a string; it is used by `print` when presenting
values. It is not particularly useful for tables,

    obj = {label = "hello"}
    print(obj) --> table: 0x80e91f8

`tostring` does let an object decide how to show itself. If the object has a metatable,
and that metatable contains a function called `__tostring`, it will use that function to
get the string:

    local MT = {
        __tostring = function(obj)
            return obj.label
        end
    }

    setmetatable(obj,MT)

    print(obj) --> hello

A more realistic example involves making tables print out their contents.  In the
specialized case of an array or list, it would look like this:

    List = {
        __tostring = function(list)
            local res = {}
            for i = 1,#list do
                res[i] = tostring(list[i])
            end
            return '{'..table.concat(res,',')..'}'
        end
    }

    function new_list(t)
        return setmetatable(t or {},List)
    end

    l1 = new_list{10,20,30}
    print(l2) ---> {10,20,30}

This is genuinely useful when working with lists.  The `__tostring` implementation is
a little more complicated than it should be, because `table.concat` itself does not use
`tostring` and needs a table of strings or numbers.  (This is actually deliberate, since
`table.concat` is _the_ way to build large strings for output in Lua.  If you make a mistake
and pass a table value or `nil`, then it is better for this to be a runtime error than
to have to look through ten pages of output for the mistake.)

The 'constructor' `new_list` takes an existing table, or makes a new table. (`t or {}` is
a common Lua idiom for specifying a default value for the case when something may
be `nil`.)    It would be more elegant if `List` could be used as a constructor, like
`List{10,20,30}`.  The `__call` metamethod makes a table _callable_.  When you try
to 'call a table' then Lua looks for a function with this name in the metatable, passing
the original table:

    setmetatable(List,{
        __call = function(C,t) return new_list(t) end
    })

    l2 = List{10,20,30}
    print(l1 == l2) --> false

It would be useful if lists could be compared element-by-element when using the
equality operator `==`.  By defining the metamethod `__eq`, the usual behaviour
is _overriden_.

    List.__eq = function(list1,list2)
        if #list1 ~= #list2 then return false end
        for i = 1,#list1 do
            if list1[i] ~= list2[i] then return false end
        end
        return true
    end

    print(li1 == l2)   --> true

`List` is starting to resemble what people call a _class_ in other languages; it serves both
as a factory for making new `List` objects, and defines shared behaviour in all these
objects.

The basic table access operations using a key are getting and setting values. If a key
is not found in the table, then `nil` is returned.   Sometimes this is not an appropriate
default value, or you want this case to really be an error.  The `__index` metamethod
is called if Lua _cannot_ find a key in a table. It is passed the table and the key:

    local ErrorMT = {}

    function ErrorMt.__index(t,key)
        error("Cannot find '"..key.."' in table",2)
    end

    function new_strict_table(t)
        return setmetatable(t or {},ErrorMT)
    end

    t = new_strict_table {fred = 1}
    --> case-sensitive!  Throws an error "Cannot find 'Fred' in table"
    print(t.Fred)

Consider counting unique words in a table:

    for i = 1,#words do
        local word = words[i]
        local count = count_of[word]
        if not count then
            count_of[word] = 0
        end
        count_of[word] = count + 1
    end

Having to check for the first occurance of a word is irritating; if the key is not found,
the value should be zero.

    ZeroMT = {
        __index = function(t,key) return 0 end
    }

Then tables with this metatable can be used like this:

    for i,word = ipairs(words) do
        count_of[word] = count_of[word] + 1
    end

Going back to the `List` example, it would be nice if lists had some methods. The `extend` method
will append all the elements of another table:

    local methods = {}

    List.__index = function(list,k) -- *note*
        return methods[k]
    end

    function methods.extend(self,list)
        local k = #self
        for i = 1,#list do
            k = k + 1
            self[k] = list[i]
        end
        return self
    end

    ls = List{10,20,30}
    ls:extend {40,50}
    print(ls) --> {10,20,30,40,50}

That is, if we can't find a key such as `extend` then `__index` assumes that it will be inside
a table of methods.

(This is such a common pattern that Lua allows `__index` to be a table, so you can write the
marked line as:

    List.__index = methods

A little less flexible, but faster and cleaner.)

It's easy to keep adding methods. For instance, this works like `string.sub`, where the second
index can be negative to refer to the end of the list:

    function methods.sub(self,i1,i2)
        if i2 == nil then
            i2 = #self
        elseif i2 < 0 then
            i2 = #self + i2 + 1
        end
        local res = List()
        for i = i1,i2 do
            res[#res + 1] = self[i]
        end
        return res
    end

    print(ls:sub(1)) --> {10,20,30,40,50}
    print(ls:sub(2,-2)) --> {20,30,40}

Such a section of a list is usually called a 'slice'. Note that calling with a start index of 1 gives
us a copy of the full list.

To make this list even more Python-like, we can implement _concatenation_. This is the new list
made from appending the second list to the first list.  `l1 .. l2` can be made to do this if
the `__concat` metamethod is defined:

    List.__concat = function(l1,l2)
        local res = self:sub(1)  --- make a copy
        return res:extend(l2)    --- and append l2
    end

    print(List{10,20} .. List{30,40} .. List{50}) --> {10,20,30,40,50}

To recap: the behaviour of any table can be changed by giving it a _metatable_, which contains
_metamethods_. The most important of these is `__index` which allows you to handle the case
where a key is not found in the table. It may simply point to a table which is used as the
'fallback' table which is examined after the first lookup fails. This is a common way to implement
object-oriented programming in Lua, allowing the methods for all objects of a given 'class'
to be stored in one place.

You could define `l1 + l2` to mean this using the metamethod `__add`, but Lua programmers
would not expect addition to work like that. They would expect that `l1 + l2` is the list made
by adding the corresponding elements of the two lists ('element-wise'), and it would
of course only work with lists where the elements _could_ be added.

The operation of setting a value can also be customized.  `__newindex` works like
`_index`; it is _only_ called if the key is not in the table. It receives three arguments, the table
itself, the key and the new value.

What if you want `__index` and `__newindex` to be _always_ called? Then the keys by definition
cannot be in the table itself.  Instead, the table must act as a _proxy_ for another table. Say we
have an array and want to raise a 'out of bounds' error instead of just silently returning `nil`.

    local ProxyListMT = {}

    function new_array(arr)
        return setmetatable({_data = arr},ProxyListMT)
    end

    function ProxyListMT.__index(self,k)
        if k < 1 or k > #self._data then error("out of bounds",2) end
        return self._data[k]
    end

    function ProxyListMT.__newindex(self,k,value)
        if k < 1 or k > #self._data then error("out of bounds",2) end
        self._data[k] = value
    end

That is, the object just contains a `_data` field which refers to the actual table; any time we
access an array element, it must go through `__index` because there are no array elements
in the object itself; it is acting as a proxy for the table.  The object behaves like a
non-resizable array.  It is naturally not quite as efficient, but it is often more important
to be _correct_ than _fast_.

