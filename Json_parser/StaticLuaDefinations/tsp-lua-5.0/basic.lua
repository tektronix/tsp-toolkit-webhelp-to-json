---@meta _

---
---Command-line arguments of Lua Standalone.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-arg"])
---
---@type string[]
arg = {}

---
---Raises an error if the value of its argument v is false (i.e., `nil` or `false`); otherwise, returns all its arguments. In case of error, `message` is the error object; when absent, it defaults to `"assertion failed!"`
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-assert"])
---
---@generic T
---@param v? T
---@param message? any
---@param ... any
---@return T
---@return any ...
function assert(v, message, ...) end

---@alias gcoptions
---|>"collect"      # Performs a full garbage-collection cycle.
---| "stop"         # Stops automatic execution.
---| "restart"      # Restarts automatic execution.
---| "count"        # Returns the total memory in Kbytes.
---| "step"         # Performs a garbage-collection step.
---| "isrunning"    # Returns whether the collector is running.
---| "setpause"     # Set `pause`.
---| "setstepmul"   # Set `step multiplier`.

---
---This function is a generic interface to the garbage collector. It performs different functions according to its first argument, `opt`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-collectgarbage"])
---
---@param opt? gcoptions
---@param arg? integer
---@return any
function collectgarbage(opt, arg) end

---
---Opens the named file and executes its content as a Lua chunk. When called without arguments, `dofile` executes the content of the standard input (`stdin`). Returns all values returned by the chunk. In case of errors, `dofile` propagates the error to its caller. (That is, `dofile` does not run in protected mode.)
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-dofile"])
---
---@param filename? string
---@return any ...
function dofile(filename) end

---
---Terminates the last protected function called and returns message as the error object.
---
---Usually, `error` adds some information about the error position at the beginning of the message, if the message is a string.
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-error"])
---
---@param message any
---@param level?  integer
function error(message, level) end

---
---A global variable (not a function) that holds the global environment (see [§2.2](command:extension.lua.doc?["en-us/51/manual.html/2.2"])). Lua itself does not use this variable; changing its value does not affect any environment, nor vice versa.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-_G"])
---
---@class _G
_G = {}

---
---Returns the current environment in use by the function. `f` can be a Lua function or a number that specifies the function at that stack level.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-getfenv"])
---
---@param f? integer|async fun(...):...
---@return table
---@nodiscard
function getfenv(f) end

---
---If object does not have a metatable, returns nil. Otherwise, if the object's metatable has a __metatable field, returns the associated value. Otherwise, returns the metatable of the given object.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-getmetatable"])
---
---@param object any
---@return table metatable
---@nodiscard
function getmetatable(object) end

---Returns two results: the number of Kbytes of dynamic memory that Lua is using and the current garbage collector threshold (also in Kbytes).
function gcinfo () end

---
---Returns three values (an iterator function, the table `t`, and `0`) so that the construction
---```lua
---    for i,v in ipairs(t) do body end
---```
---will iterate over the key–value pairs `(1,t[1]), (2,t[2]), ...`, up to the first absent index.
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-ipairs"])
---
---@generic T: table, V
---@param t T
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
function ipairs(t) end

---
---Loads a file as a Lua chunk (without running it). If there are no errors, returns the compiled chunk as a function; otherwise, returns nil plus the error message. The environment of the returned function is the global environment.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-loadfile"])
---
---@param filename? string
---@return function?
---@return string?  error_message
---@nodiscard
function loadfile(filename) end

---
---Links the program with the dynamic C library libname. Inside this library, looks for a function funcname and returns this function as a C function.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-loadfile"])
---
---@param libname? string
---@param funcname? string
---@return function?
---@return string?  error_message
---@nodiscard
function loadlib(libname, funcname) end
---
---Loads a chunk from the given string.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-loadstring"])
---
---@param text       string
---@param chunkname? string
---@return function?
---@return string?   error_message
---@nodiscard
function loadstring(text, chunkname) end

---
---Allows a program to traverse all fields of a table. Its first argument is a table and its second argument is an index in this table. A call to `next` returns the next index of the table and its associated value. When called with `nil` as its second argument, `next` returns an initial index and its associated value. When called with the last index, or with `nil` in an empty table, `next` returns `nil`. If the second argument is absent, then it is interpreted as `nil`. In particular, you can use `next(t)` to check whether a table is empty.
---
---The order in which the indices are enumerated is not specified, *even for numeric indices*. (To traverse a table in numerical order, use a numerical `for`.)
---
---The behavior of `next` is undefined if, during the traversal, you assign any value to a non-existent field in the table. You may however modify existing fields. In particular, you may set existing fields to nil.
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-next"])
---
---@generic K, V
---@param table table<K, V>
---@param index? K
---@return K?
---@return V?
---@nodiscard
function next(table, index) end

---
---If `t` has a metamethod `__pairs`, calls it with t as argument and returns the first three results from the call.
---
---Otherwise, returns three values: the [next](command:extension.lua.doc?["en-us/51/manual.html/pdf-next"]) function, the table `t`, and `nil`, so that the construction
---```lua
---    for k,v in pairs(t) do body end
---```
---will iterate over all key–value pairs of table `t`.
---
---See function [next](command:extension.lua.doc?["en-us/51/manual.html/pdf-next"]) for the caveats of modifying the table during its traversal.
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-pairs"])
---
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
function pairs(t) end

---
---Calls the function `f` with the given arguments in *protected mode*. This means that any error inside `f` is not propagated; instead, `pcall` catches the error and returns a status code. Its first result is the status code (a boolean), which is true if the call succeeds without errors. In such case, `pcall` also returns all results from the call, after this first result. In case of any error, `pcall` returns `false` plus the error object.
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-pcall"])
---
---@param f     function
---@param arg1? any
---@param ...   any
---@return boolean success
---@return any result
---@return any ...
function pcall(f, arg1, ...) end

---
---Receives any number of arguments and prints their values to `stdout`, converting each argument to a string following the same rules of [tostring](command:extension.lua.doc?["en-us/51/manual.html/pdf-tostring"]).
---The function print is not intended for formatted output, but only as a quick way to show a value, for instance for debugging. For complete control over the output, use [string.format](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.format"]) and [io.write](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.write"]).
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-print"])
---
---@param ... any
function print(...) end

---
---Checks whether v1 is equal to v2, without invoking the `__eq` metamethod.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-rawequal"])
---
---@param v1 any
---@param v2 any
---@return boolean
---@nodiscard
function rawequal(v1, v2) end

---
---Gets the real value of `table[index]`, without invoking the `__index` metamethod.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-rawget"])
---
---@param table table
---@param index any
---@return any
---@nodiscard
function rawget(table, index) end


---
---Sets the real value of `table[index]` to `value`, without using the `__newindex` metavalue. `table` must be a table, `index` any value different from `nil` and `NaN`, and `value` any Lua value.
---This function returns `table`.
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-rawset"])
---
---@param table table
---@param index any
---@param value any
---@return table
function rawset(table, index, value) end

---
---Loads the given module, returns any value returned by the given module(`true` when `nil`).
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-require"])
---
---@param modname string
---@return unknown
function require(modname) end

---
---Sets the environment to be used by the given function.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-setfenv"])
---
---@param f     (async fun(...):...)|integer
---@param table table
---@return function
function setfenv(f, table) end


---@class metatable
---@field __mode 'v'|'k'|'kv'|nil
---@field __metatable any|nil
---@field __tostring (fun(t):string)|nil
---@field __gc fun(t)|nil
---@field __add (fun(t1,t2):any)|nil
---@field __sub (fun(t1,t2):any)|nil
---@field __mul (fun(t1,t2):any)|nil
---@field __div (fun(t1,t2):any)|nil
---@field __mod (fun(t1,t2):any)|nil
---@field __pow (fun(t1,t2):any)|nil
---@field __unm (fun(t):any)|nil
---@field __concat (fun(t1,t2):any)|nil
---@field __len (fun(t):integer)|nil
---@field __eq (fun(t1,t2):boolean)|nil
---@field __lt (fun(t1,t2):boolean)|nil
---@field __le (fun(t1,t2):boolean)|nil
---@field __index table|(fun(t,k):any)|nil
---@field __newindex table|fun(t,k,v)|nil
---@field __call (fun(t,...):...)|nil

---
---Sets the metatable for the given table. If `metatable` is `nil`, removes the metatable of the given table. If the original metatable has a `__metatable` field, raises an error.
---
---This function returns `table`.
---
---To change the metatable of other types from Lua code, you must use the debug library ([§6.10](command:extension.lua.doc?["en-us/51/manual.html/6.10"])).
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-setmetatable"])
---
---@param table      table
---@param metatable? metatable|table
---@return table
function setmetatable(table, metatable) end

---
---When called with no `base`, `tonumber` tries to convert its argument to a number. If the argument is already a number or a string convertible to a number, then `tonumber` returns this number; otherwise, it returns `fail`.
---
---The conversion of strings can result in integers or floats, according to the lexical conventions of Lua (see [§3.1](command:extension.lua.doc?["en-us/51/manual.html/3.1"])). The string may have leading and trailing spaces and a sign.
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-tonumber"])
---
---@overload fun(e: string, base: integer):integer
---@param e any
---@return number?
---@nodiscard
function tonumber(e) end

---
---Receives a value of any type and converts it to a string in a human-readable format.
---
---If the metatable of `v` has a `__tostring` field, then `tostring` calls the corresponding value with `v` as argument, and uses the result of the call as its result. Otherwise, if the metatable of `v` has a `__name` field with a string value, `tostring` may use that string in its final result.
---
---For complete control of how numbers are converted, use [string.format](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.format"]).
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-tostring"])
---
---@param v any
---@return string
---@nodiscard
function tostring(v) end

---@alias type
---| "nil"
---| "number"
---| "string"
---| "boolean"
---| "table"
---| "function"
---| "thread"
---| "userdata"

---
---Returns the type of its only argument, coded as a string. The possible results of this function are `"nil"` (a string, not the value `nil`), `"number"`, `"string"`, `"boolean"`, `"table"`, `"function"`, `"thread"`, and `"userdata"`.
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-type"])
---
---@param v any
---@return type type
---@nodiscard
function type(v) end

---
---A global variable (not a function) that holds a string containing the running Lua version.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-_VERSION"])
---
_VERSION = "Lua 5.0"


---
---Calls function `f` with the given arguments in protected mode with a new message handler.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-xpcall"])
---
---@param f     function
---@param err   function
---@return boolean success
---@return any result
---@return any ...
function xpcall(f, err) end


---
---Returns the elements from the given `list`. This function is equivalent to
---```lua
---    return list[i], list[i+1], ···, list[j]
---```
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-unpack"])
---
---@generic T
---@param list T[]
---@return T   ...
---@nodiscard
function unpack(list) end

