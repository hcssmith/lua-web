M = {}


M.Request = {
  Headers = {},
  Path = "",
  Method = "",
}

function M.Request:New()
  local o = {}
  self.__index = self
  return setmetatable(o, self)
end

function M.Request:Recieve(client)
  while true do
    local line, err = client:receive()
    if not err then
      if line == "" then
        break
      else
        if self.Path == "" then
          local _, _, method, path, _ = line:find("^(%u+)%s+(%S+)%s+HTTP")
          self.Path = path
          self.Method = method
        else
          local key, value = line:match("(.-):%s*(.*)")
            if key and value then
              self.Headers[key] = value
            end
          end
      end
    else
      break
    end
  end
end

return M
