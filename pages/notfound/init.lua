
M = {}

local tpl = require('templating')
local resp = require('server.response')


function M.NotFound(req)
  local r = resp.Response:New()
  local t = tpl.Template:New()
  t.Header = {
    Title = 'hcssmith.com',
    SubTitle = 'Home',
    Menu = {
      Home = '/'
    }
  }
  t.Body.Text = '<h1>Not Found</h1>'
  r.Protocol = 'HTTP/1.1'
  r.StatusCode = 404
  r.StatusMessage = 'NOT FOUND'
  r.ContentType = 'text/html'
  r.Body = t:ToString()
  return r
end

return M
