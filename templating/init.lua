M = {}

local switch = require('util').Switch

local doctype = [[<!DOCTYPE html>
]]
local begin = [[
<html>
  <head>
  ]]
local htb = [[
  </head>
  <body>
  ]]
local close = [[
  </body>
</html>]]

M.Template = {
  Includes = {}, -- Array of Type / Ref
  Header = {},
  Body = {},
  Footer = '',
}

function M.Template.Body:ToString()
  if self.Src ~= nil then
    local extension = self.Src:match("^.+(%..+)$")
    local ret = switch(extension, {
      ['.html'] = function ()
        local f = assert(io.open(self.Src, "rb"))
        local content = f:read("*a")
        f:close()
        return content
      end,
      ['.md'] = function ()
        local pandoc_command = 'pandoc ' .. self.Src
        local openPop = assert(io.popen(pandoc_command, 'r'))
        local output = openPop:read('*all')
        openPop:close()
        return output
      end

    })
    return ret
  elseif self.Text ~= nil then
    return self.Text
  else
    return ''
  end
end

function M.Template.Includes:Add(type, reference)
  table.insert(self, {Type = type, Ref = reference})
end

function M.Template.Includes:New()
  local o = {}
  self.__index = self
  return setmetatable(o, self)
end

function M.Template.Body:New()
  local o = {}
  self.__index = self
  return setmetatable(o, self)
end


function M.Template:New()
  local o = {}
  self.__index = self
  o = setmetatable(o, self)
  o.Includes = o.Includes:New()
  o.Body = o.Body:New()
  return o
end


function M.Template:ToString()
  local output = doctype .. begin
  for _, v in ipairs(self.Includes) do
    local include = switch(v.Type, {
      ['css'] = function () return "<link rel=\"stylesheet\" href=\"" .. v.Ref .. "\">\n" end,
      ['js'] = function () return "<style src=\"" .. v.Ref .. "\"></stlye>\n" end
    })
    output = output .. include
  end
  output = output .. '<title>' .. self.Header.Title .. '</title>\n'
  output = output .. htb
  output = output .. '<header>'
  if self.Header['Title'] ~= nil then
    output = output .. '<h1>' .. self.Header.Title .. '</h1>\n'
  end
  if self.Header['SubTitle'] ~= nil then
    output = output .. '<h2>' .. self.Header.SubTitle .. '</h2>\n'
  end
  output = output .. '</header>'
  output = output .. '<nav><ul>\n'
  for k,v in pairs(self.Header.Menu) do
    local li = '<li><a href="' .. v .. '">' .. k .. '</a></li>\n'
    output = output .. li
  end
  output = output .. '</ul></nav>'
  output = output .. '<main>'
  output = output .. self.Body:ToString()
  output = output .. '</main>'
  output = output .. '<footer>'
  output = output .. self.Footer
  output = output .. '</footer>'

  output = output .. close

  return output
end

return M
