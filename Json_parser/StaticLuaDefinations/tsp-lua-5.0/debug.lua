---@meta debug

---
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-debug"])
---
---@class debuglib
debug = {}

---@class debuginfo
---@field name            string
---@field namewhat        string
---@field source          string
---@field short_src       string
---@field linedefined     integer
---@field lastlinedefined integer
---@field what            string
---@field currentline     integer
---@field istailcall      boolean
---@field nups            integer
---@field func            function
---@field activelines     table

---
---Enters an interactive mode with the user, running each string that the user enters.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-debug.debug"])
---
function debug.debug() end

---
---Returns the current hook settings of the thread.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-debug.gethook"])
---
---@param co? thread
---@return function hook
---@return string mask
---@return integer count
---@nodiscard
function debug.gethook(co) end

---@alias infowhat string
---|+"n"     # `name` and `namewhat`
---|+"S"     # `source`, `short_src`, `linedefined`, `lastlinedefined`, and `what`
---|+"l"     # `currentline`
---|+"t"     # `istailcall`
---|+"u" # `nups`
---|+"f"     # `func`
---|+"L"     # `activelines`

---
---Returns a table with information about a function.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-debug.getinfo"])
---
---@overload fun(f: integer|function, what?: infowhat):debuginfo
---@param thread thread
---@param f      integer|async fun(...):...
---@param what?  infowhat
---@return debuginfo
---@nodiscard
function debug.getinfo(thread, f, what) end

---
---Returns the name and the value of the local variable with index `local` of the function at level `level` of the stack.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-debug.getlocal"])
---
---@overload fun(level: integer, index: integer):string, any
---@param thread  thread
---@param level   integer
---@param index   integer
---@return string name
---@return any    value
---@nodiscard
function debug.getlocal(thread, level, index) end

---
---Returns the name and the value of the upvalue with index `up` of the function.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-debug.getupvalue"])
---
---@param f  async fun(...):...
---@param up integer
---@return string name
---@return any    value
---@nodiscard
function debug.getupvalue(f, up) end

---
---Assigns the `value` to the local variable with index `local` of the function at `level` of the stack.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-debug.setlocal"])
---
---@overload fun(level: integer, index: integer, value: any):string
---@param thread thread
---@param level  integer
---@param index  integer
---@param value  any
---@return string name
function debug.setlocal(thread, level, index, value) end

---
---Assigns the `value` to the upvalue with index `up` of the function.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-debug.setupvalue"])
---
---@param f     async fun(...):...
---@param up    integer
---@param value any
---@return string name
function debug.setupvalue(f, up, value) end


---@alias hookmask string
---|+"c" # Calls hook when Lua calls a function.
---|+"r" # Calls hook when Lua returns from a function.
---|+"l" # Calls hook when Lua enters a new line of code.

---
---Sets the given function as a hook.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-debug.sethook"])
---
---@overload fun(hook: (async fun(...):...), mask: hookmask, count?: integer)
---@overload fun(thread: thread):...
---@overload fun(...):...
---@param thread thread
---@param hook   async fun(...):...
---@param mask   hookmask
---@param count? integer
function debug.sethook(thread, hook, mask, count) end

---
---Returns a string with a traceback of the call stack. The optional message string is appended at the beginning of the traceback.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-debug.traceback"])
---
---@overload fun(message?: any, level?: integer): string
---@param thread   thread
---@param message? any
---@param level?   integer
---@return string  message
---@nodiscard
function debug.traceback(thread, message, level) end

return debug
