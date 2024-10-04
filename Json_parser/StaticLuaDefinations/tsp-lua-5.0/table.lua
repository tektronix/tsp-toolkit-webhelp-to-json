---@meta table

---
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-table"])
---
---@class tablelib
table = {}

---
---Given a list where all elements are strings or numbers, returns the string `list[i]..sep..list[i+1] ··· sep..list[j]`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-table.concat"])
---
---@param list table
---@param sep? string
---@param i?   integer
---@param j?   integer
---@return string
---@nodiscard
function table.concat(list, sep, i, j) end

---
---Executes the given f over all elements of table. For each element, f is called with the index and respective value as arguments. If f returns a non-nil value, then the loop is broken, and this value is returned as the final value of foreach.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-table.foreach"])
---
---@generic T
---@param list any
---@param callback fun(key: string, value: any):T|nil
---@return T|nil
---@deprecated
function table.foreach(list, callback) end

---
---Executes the given f over the numerical indices of table. For each index, f is called with the index and respective value as arguments. Indices are visited in sequential order, from 1 to n, where n is the size of the table. If f returns a non-nil value, then the loop is broken and this value is returned as the result of foreachi.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-table.foreachi"])
---
---@generic T
---@param list any
---@param callback fun(key: string, value: any):T|nil
---@return T|nil
---@deprecated
function table.foreachi(list, callback) end

---
---Returns the number of elements in the table. This function is equivalent to `#list`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-table.getn"])
---
---@generic T
---@param list T[]
---@return integer
---@nodiscard
---@deprecated
function table.getn(list) end

---
---Sorts list elements in a given order, *in-place*, from `list[1]` to `list[#list]`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-table.sort"])
---
---@generic T
---@param list T[]
---@param comp? fun(a: T, b: T):boolean
function table.sort(list, comp) end

---
---Inserts element `value` at position `pos` in `list`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-table.insert"])
---
---@overload fun(list: table, value: any)
---@param list table
---@param pos integer
---@param value any
function table.insert(list, pos, value) end

---
---Removes from `list` the element at position `pos`, returning the value of the removed element.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-table.remove"])
---
---@param list table
---@param pos? integer
---@return any
function table.remove(list, pos) end

---
---Returns the number of elements in the table. This function is equivalent to `#list`.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-table.setn"])
---
---@generic T
---@param list T[]
---@param n number
function table.setn(list, n) end


return table
