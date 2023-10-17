M = {}

M.Response = {
  Body = '',
  ResponseHeaders = {},
  ContentType = '',
  StatusCode = 0,
  StatusMessage = '',
  Protocol = ''
}

function M.Response:New()
  local o = {}
  self.__index = self
  o = setmetatable(o, self)
  o.Body = {}
  return o
end

function M.Response:ToString()
  local start = self.Protocol .. " " .. self.StatusCode .. " " .. self.StatusMessage
  local headers = ""
  for k, v in pairs(self.ResponseHeaders) do
    local header = k .. ": " .. v
    headers = headers .. header .. "\n"
  end
  headers = headers .. 'Content-Type: ' .. self.ContentType
  return start .. "\n" .. headers .. "\n\n" .. self.Body
end

return M
