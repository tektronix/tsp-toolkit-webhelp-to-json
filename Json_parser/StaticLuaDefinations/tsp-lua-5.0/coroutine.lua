---@meta coroutine

---
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-coroutine"])
---
---@class coroutinelib
coroutine = {}

---
---Creates a new coroutine, with body `f`. `f` must be a function. Returns this new coroutine, an object with type `"thread"`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-coroutine.create"])
---
---@param f async fun(...):...
---@return thread
---@nodiscard
function coroutine.create(f) end

---
---Starts or continues the execution of coroutine `co`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-coroutine.resume"])
---
---@param co    thread
---@param val1? any
---@return boolean success
---@return any ...
function coroutine.resume(co, val1, ...) end

---
---Returns the status of coroutine `co`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-coroutine.status"])
---
---@param co thread
---@return
---| '"running"'   # Is running.
---| '"suspended"' # Is suspended or not started.
---| '"dead"'      # Has finished or stopped with an error.
---@nodiscard
function coroutine.status(co) end

---
---Creates a new coroutine, with body `f`; `f` must be a function. Returns a function that resumes the coroutine each time it is called.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-coroutine.wrap"])
---
---@param f async fun(...):...
---@return fun(...):...
---@nodiscard
function coroutine.wrap(f) end

---
---Suspends the execution of the calling coroutine.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-coroutine.yield"])
---
---@async
---@return any ...
function coroutine.yield(...) end

return coroutine
