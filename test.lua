package.path="../multi/?/init.lua;?.lua;"..package.path -- use multi devbuild
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
list = mangaReader.init().wait()
mangaReader.storeList(list)
title = mangaReader.getList()[234]
manga = mangaReader.getManga(title).wait()
page = mangaReader.getPages(manga,1).wait()
multi:mainloop()