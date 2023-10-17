M = {}

local tpl = require('templating')
local resp = require('server.response')


function M.Home(req)
  local r = resp.Response:New()
  local t = tpl.Template:New()
  t.Includes:Add('css', '/css/test.css')
  t.Header = {
    Title = 'hcssmith.com',
    SubTitle = 'Home',
    Menu = {
      Home = '/'
    }
  }
  t.Body.Src = 'pages/home/home.md'
  r.Protocol = 'HTTP/1.1'
  r.StatusCode = 200
  r.StatusMessage = 'OK'
  r.ContentType = 'text/html'
  r.Body = t:ToString()
  return r
end

return M
