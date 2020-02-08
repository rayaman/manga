package.path="?/init.lua;?.lua;"..package.path
local http = require("socket.http")
require("bin")
-- local dat = http.request("http://www.mangareader.net/ichiba-kurogane-wa-kasegitai/1")
-- a-z list: http://www.mangareader.net/alphabetical
-- mangapage: http://www.mangareader.net/ichiba-kurogane-wa-kasegitai
-- chapter: http://www.mangareader.net/ichiba-kurogane-wa-kasegitai/1
-- bin.new(dat):tofile("chapter.html")
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
-- local mangaReader = require("manga"):init()
-- title = mangaReader:getList()[234]
-- manga = mangaReader:getManga(title)
-- page = mangaReader:getPages(manga,1)
-- tprint(page)
