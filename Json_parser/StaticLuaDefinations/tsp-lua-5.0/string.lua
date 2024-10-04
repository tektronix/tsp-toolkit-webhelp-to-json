---@meta string

---
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string"])
---
---@class stringlib
string = {}

---
---Returns the internal numeric codes of the characters `s[i], s[i+1], ..., s[j]`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.byte"])
---
---@param s  string|number
---@param i? integer
---@param j? integer
---@return integer ...
---@nodiscard
function string.byte(s, i, j) end

---
---Returns a string with length equal to the number of arguments, in which each character has the internal numeric code equal to its corresponding argument.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.char"])
---
---@param byte integer
---@param ... integer
---@return string
---@nodiscard
function string.char(byte, ...) end

---
---Returns a string containing a binary representation (a *binary chunk*) of the given function.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.dump"])
---
---@param f      async fun(...):...
---@return string
---@nodiscard
function string.dump(f) end

---
---Looks for the first match of `pattern` (see [§6.4.1](command:extension.lua.doc?["en-us/51/manual.html/6.4.1"])) in the string.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.find"])
---
---@param s       string|number
---@param pattern string|number
---@param init?   integer
---@param plain?  boolean
---@return integer|nil start
---@return integer|nil end
---@return any|nil ... captured
---@nodiscard
function string.find(s, pattern, init, plain) end

---
---Returns its length.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.len"])
---
---@param s string|number
---@return integer
---@nodiscard
function string.len(s) end

---
---Returns a copy of this string with all uppercase letters changed to lowercase.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.lower"])
---
---@param s string|number
---@return string
---@nodiscard
function string.lower(s) end

---
---Returns a string that is the concatenation of `n` copies of the string `s` .
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.rep"])
---
---@param s    string|number
---@param n    integer
---@return string
---@nodiscard
function string.rep(s, n) end

---
---Returns the substring of the string that starts at `i` and continues until `j`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.sub"])
---
---@param s  string|number
---@param i  integer
---@param j? integer
---@return string
---@nodiscard
function string.sub(s, i, j) end

---
---Returns a copy of this string with all lowercase letters changed to uppercase.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.upper"])
---
---@param s string|number
---@return string
---@nodiscard
function string.upper(s) end

---
---Returns a formatted version of its variable number of arguments following the description given in its first argument.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.format"])
---
---@param s string|number
---@param ... any
---@return string
---@nodiscard
function string.format(s, ...) end

---
---Returns an iterator function that, each time it is called, returns the next captures from `pattern` (see [§6.4.1](command:extension.lua.doc?["en-us/51/manual.html/6.4.1"])) over the string s.
---
---As an example, the following loop will iterate over all the words from string s, printing one per line:
---```lua
---    s =
---"hello world from Lua"
---    for w in string.gmatch(s, "%a+") do
---        print(w)
---    end
---```
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.gmatch"])
---
---@param s       string|number
---@param pattern string|number
---@return fun():string, ...
---@nodiscard
function string.gfind (s, pattern) end

---
---Returns a copy of s in which all (or the first `n`, if given) occurrences of the `pattern` (see [§6.4.1](command:extension.lua.doc?["en-us/51/manual.html/6.4.1"])) have been replaced by a replacement string specified by `repl`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-string.gsub"])
---
---@param s       string|number
---@param pattern string|number
---@param repl    string|number|table|function
---@param n?      integer
---@return string
---@return integer count
function string.gsub(s, pattern, repl, n) end

return string
