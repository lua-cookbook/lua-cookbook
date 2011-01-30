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
    

The operation of setting a value can also be customized.  `__newindex` works like 
`_index`; it is only called if the key is not in the table.

Unlike the other metamethods, `__index` may be a table. 

