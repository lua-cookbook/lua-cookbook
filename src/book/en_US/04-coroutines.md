## Coroutines

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
return and we print out 2, etc. The key idea is that the coroutine _remembers where
it was_ and resumes where it last was executing.

So each coroutine preserves its complete state, and is sleeping when not explicitly
resumed. This is often called 'cooperative multitasking' because one coroutine has
to yield for another coroutine to resume.

`coroutine.wrap` will construct a function which resumes a coroutine.

    f = coroutine.wrap(coco)
    print(f()) -- 1
    print(f()) -- 2
    print(f()) -- 3
    print(f()) -- nil

(This is convenient, but if there is a problem an error will be raised and will
need to be handled.
With  `coroutine.resume` the first returned value is the status; if it's `false`
then the second value is the error, just like `pcall`.)

This is exactly what Lua considers a simple iterator: a function which can be
repeatedly called,  returning new values and indicating the end with a `nil`.

Coroutines help in making iterators where the logic is not so straightforward
as the previous examples.  Consider the following data structure:

T = {
    value = 10,
    left = {
        value = 20,
        left = {value = 40},
        right = {value = 50},
    },
    right = {
        value = 30
    }
}

This kind of structure is often called a _tree_, in this case a binary tree because
there are at most two branches at each note. The end nodes are often called
_leaves_ because they have no branches.

A recursive function for printing all the values is easy to write

    function traverse(t)
        if t.left then traverse(t.left) end
        print (t.value)
        if t.right then traverse(t.right) end
    end

    traverse(T)
    -->
    40
    20
    50
    10
    30

This function will keep visiting the left branches until there isn't any, so it first
visits `left = {value = 20..` and then `left = {value = 40}`; this node has no `left`
so it prints out `value` (40), and so on.

Now comes the key part: replace the `print` with `coroutine.yield` and turn it
into a coroutine:

    function traverse(t)
        if t.left then traverse(t.left) end
        coroutine.yield (t.value)
        if t.right then traverse(t.right) end
    end

    c = coroutine.create(traverse)
    print(coroutine.resume(c,T)) -- true   40
    print(coroutine.resume(c,T)) -- true    20

This can be made into an iterator if we make a function of no arguments from this
coroutine:

    function tree_iter(t)
        return coroutine.wrap(function()
            return traverse(t)
        end)
    end

    for v in tree_iter(T) do print(v) end
     -->
    40
    20
    50
    10
    30

`tree_iter` returns the iterator.
Each time it is called, the coroutine yields, returning the value of
the node. We keep yielding until the function finishes, when it returns `nil`.

!feels a little difficult, not so?!
