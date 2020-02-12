package.path="../multi/?/init.lua;?.lua;"..package.path -- use multi devbuild
local pairs, setmetatable = pairs, setmetatable
local mt -- metatable
mt = {
  __add = function(s1, s2) -- union
    local s = {}
    for e in pairs(s1) do s[e] = true end
    for e in pairs(s2) do s[e] = true end
    return setmetatable(s, mt)
  end,
  __mul = function(s1, s2) -- intersection
    local s = {}
    for e in pairs(s1) do
      if s2[e] then s[e] = true end
    end
    return setmetatable(s, mt)
  end,
  __sub = function(s1, s2) -- set difference
    local s = {}
    for e in pairs(s1) do
      if not s2[e] then s[e] = true end
    end
    return setmetatable(s, mt)
  end,
  __tostring = function(s)
	return table.concat(s,",")
  end
}

local card = function(s) -- #elements
  local n = 0
  for k in pairs(s) do n = n + 1 end
  return n
end

Set = setmetatable({elements = pairs, card = card}, {
  __call = function(_, t) -- new set
    local t = t or {}
    local s = {}
    for _, e in pairs(t) do s[e:lower()] = true end
    return setmetatable(s, mt)
  end
})
function tprint (tbl, indent)
	if not indent then indent = 0 end
	for k, v in pairs(tbl) do
		formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			tprint(v, indent+1)
		elseif type(v) == 'boolean' then
			print(formatting .. tostring(v))      
		else
			print(formatting .. v)
		end
	end
end
multi,thread = require("multi"):init()
GLOBAL,THREAD = require("multi.integration.lanesManager"):init()
mangaReader = require("manga")
mangaReader.storeList(mangaReader.init().wait())
print(mangaReader.getList())
local titles = mangaReader.getList()
str = "boku no"
function string:split(pat)
	local list = {}
	for i in self:gmatch("[^"..(pat or ",").."]+") do
		list[#list+1] = i
	end
	return list
end

function searchFor(query)
	local str = query:split(" ")
	local query = Set(str)
	local list = {}
	for i,v in pairs(titles) do
		local t = Set(v.Title:split(" "))
		local tab = {}
		for k in Set.elements(query*t) do table.insert(tab,k) end
		if #tab==Set.card(query) then
			table.insert(list,v)
		end
	end
	return list
end
tprint(searchFor("Kenichi"))
--multi:mainloop()