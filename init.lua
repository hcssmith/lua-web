local srv = require('server').Server:New('localhost', 8080)

local homepage = require('pages.home')
local notfound = require('pages.notfound')
local static = require('pages.static')

srv:AddRoute("/", homepage.Home )
srv:AddRoute("404", notfound.NotFound )
srv:AddRoute("/css/(%w+)%.css",  static.Css, 'pattern')
srv:Loop()
