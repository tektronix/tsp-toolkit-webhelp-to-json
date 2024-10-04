---@meta io

---
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io"])
---
---@class iolib
---
---standard input.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.stdin"])
---
---@field stdin  file*
---
---standard output.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.stdout"])
---
---@field stdout file*
---
---standard error.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.stderr"])
---
---@field stderr file*
io = {}

---@alias openmode
---|>"r"   # Read mode.
---| "w"   # Write mode.
---| "a"   # Append mode.
---| "r+"  # Update mode, all previous data is preserved.
---| "w+"  # Update mode, all previous data is erased.
---| "a+"  # Append update mode, previous data is preserved, writing is only allowed at the end of file.

---
---Close `file` or default output file.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.close"])
---
---@param file? file*
---@return boolean?  suc
---@return exitcode? exitcode
---@return integer?  code
function io.close(file) end

---
---Saves any written data to default output file.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.flush"])
---
function io.flush() end

---
---Sets `file` as the default input file.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.input"])
---
---@overload fun():file*
---@param file string|file*
function io.input(file) end

---
---------
---```lua
---for c in io.lines(filename, ...) do
---    body
---end
---```
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.lines"])
---
---@param filename string?
---@param ... readmode
---@return fun():any, ...
function io.lines(filename, ...) end

---
---Opens a file, in the mode specified in the string `mode`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.open"])
---
---@param filename string
---@param mode?    openmode
---@return file*?
---@return string? errmsg
---@nodiscard
function io.open(filename, mode) end

---
---Sets `file` as the default output file.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.output"])
---
---@overload fun():file*
---@param file string|file*
function io.output(file) end

---
---Reads the `file`, according to the given formats, which specify what to read.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.read"])
---
---@param ... readmode
---@return any
---@return any ...
---@nodiscard
function io.read(...) end

---
---In case of success, returns a handle for a temporary file.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.tmpfile"])
---
---@return file*
---@nodiscard
function io.tmpfile() end

---@alias filetype
---| "file"        # Is an open file handle.
---| "closed file" # Is a closed file handle.
---| `nil`         # Is not a file handle.

---
---Checks whether `obj` is a valid file handle.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.type"])
---
---@param file file*
---@return filetype
---@nodiscard
function io.type(file) end

---
---Writes the value of each of its arguments to default output file.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-io.write"])
---
---@return file*
---@return string? errmsg
function io.write(...) end

---
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-file"])
---
---@class file*
local file = {}

---@alias readmode integer|string
---| "*n" # Reads a numeral and returns it as number.
---| "*a" # Reads the whole file.
---|>"*l" # Reads the next line skipping the end of line.

---@alias exitcode "exit"|"signal"

---
---Close `file`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-file:close"])
---
---@return boolean?  suc
---@return exitcode? exitcode
---@return integer?  code
function file:close() end

---
---Saves any written data to `file`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-file:flush"])
---
function file:flush() end

---
---------
---```lua
---for c in file:lines(...) do
---    body
---end
---```
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-file:lines"])
---
---@param ... readmode
---@return fun():any, ...
function file:lines(...) end

---
---Reads the `file`, according to the given formats, which specify what to read.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-file:read"])
---
---@param ... readmode
---@return any
---@return any ...
---@nodiscard
function file:read(...) end

---@alias seekwhence
---| "set" # Base is beginning of the file.
---|>"cur" # Base is current position.
---| "end" # Base is end of file.

---
---Sets and gets the file position, measured from the beginning of the file.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-file:seek"])
---
---@param whence? seekwhence
---@param offset? integer
---@return integer offset
---@return string? errmsg
function file:seek(whence, offset) end

---
---Writes the value of each of its arguments to `file`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-file:write"])
---
---@param ... string|number
---@return file*?
---@return string? errmsg
function file:write(...) end

return io
