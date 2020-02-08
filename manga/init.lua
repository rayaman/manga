local http = require("socket.http")
local m = {}
local _init = false
m.azlist = {}
function m:init()
    if _init then return end
    _init = true
    local list = http.request("http://www.mangareader.net/alphabetical")
    self:_getList(list)
    return self
end
function m:refresh()
    _init=false;self:init()
end
-- return title
function m:getList()
    return self.azlist
end
function m:_getList(list)
    local go = false
    local titles = {}
    for link,title in list:gmatch("<li><a href=\"([^\"]+)\">([^<]+)[^>]+></li>") do
        if go and link~="/" and link~="/privacy" then
            table.insert(titles,{Title = title,Link = "http://www.mangareader.net"..link})
        end
        if title=="Z" then
            go = true
        end
    end
    self.azlist = titles
end
-- returns manga
function m:getManga(title)
    local manga = http.request(title.Link)
    local tab = {}
    tab.Cover = manga:match([[<div id="mangaimg"><img src="(.-)"]])
    tab.Title = manga:match([[Name:.-"aname">%s*([^<]*)]])
    tab.AltTitle = manga:match([[Alternate Name:.-<td>([^<]*)]])
    tab.Status = manga:match([[Status:.-<td>([^<]*)]])
    tab.Author = manga:match([[Author:.-<td>([^<]*)]])
    tab.Artist = manga:match([[Artist:.-<td>([^<]*)]])
    tab.ReadingDir = manga:match([[Reading Direction:.-<td>([^<]*)]])
    local data = manga:match([[readmangasum(.*)]])
    tab.Desc = manga:match([[<p>(.-)</p>]])
    tab.Chapters = {}
    for link,chapter in data:gmatch([[<a href="([^"]+)">([^<]+)]]) do
        if link~="/" and link~="/privacy" then
            table.insert(tab.Chapters,{Link = "http://www.mangareader.net"..link,Lead = chapter})
        end
    end
    return tab
end
-- returns pages
function m:getImage(pageurl)
    local page = http.request(pageurl)
    return page:match([[id="imgholder.-src="([^"]*)]])
end
function m:getPages(manga,chapter)
    local tab = {}
    local page = http.request(manga.Chapters[chapter].Link)
    tab.pages = {page:match([[id="imgholder.-src="([^"]*)]])}
    tab.nextChapter = "http://www.mangareader.net"..page:match([[Next Chapter:.-href="([^"]*)]])
    for link,page in page:gmatch([[<option value="([^"]*)">(%d*)</option>]]) do
        table.insert(tab.pages,self:getImage("http://www.mangareader.net"..link))
    end
    return tab
end
return m