M = {}

local socket = require("socket")
local request = require('server.request')
local routes = require('server.routing')


M.Server = {}


function M.Server:New(host, port)
  local o = {}
  local sock = socket.bind(host, port)
  print("Server listening on port 8080...")
  o.Socket = sock
  o.RouteCollection = routes.RouteCollection:New()
  self.__index = self
  return setmetatable(o, self)
end

function M.Server:Loop()
  while true do
    local client = self.Socket:accept()
    client:settimeout(10)
    local req = request.Request:New()
    req:Recieve(client)
    local response = ''
    local rf = self.RouteCollection.Routes[req.Path]
    if rf ~= nil then
      response = rf(req)
    end
    if response == '' then
      rf = self.RouteCollection.Routes['404']
      response = rf(req)
    end


    print("[" ..  os.date("%Y-%m-%d %H:%M:%S").. "] " .. req.Method .. " " .. req.Path)
    client:send(response:ToString())
    client:close()
  end
end

function M.Server:AddRoute(path, func, pattern)
  self.RouteCollection:AddRoute(path, func, pattern)
end

return M
