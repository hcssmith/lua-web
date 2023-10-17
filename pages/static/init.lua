M = {}

local resp = require('server.response')


function M.Css(req)
  
  local filename = req.Path:match('/css/(%w+)%.css') .. '.css'
  local f = assert(io.open('./pages/static/' .. filename, "rb"))
  local content = f:read("*a")
  f:close()
  local r = resp.Response:New()
  r.Protocol = 'HTTP/1.1'
  r.StatusCode = 200
  r.StatusMessage = 'OK'
  r.ContentType = 'text/css'
  r.Body = content
  return r
end

return M
