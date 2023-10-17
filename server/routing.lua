M = {}

M.RouteCollection = {
  Routes = {}
}

local routesMetatable = {
  __index = function (arr, key)
    local i = 1
    while i<=#arr do
      if arr[i].Path ~= nil and arr[i].Type ~= nil then
        if arr[i].Type == 'exact' then
          if arr[i].Path == key then return arr[i].Function end
        elseif arr[i].Type == 'pattern' then
          if key:match(arr[i].Path) ~= nil then
            return arr[i].Function
          end
        end
      end
      i = i+1
    end
    return nil
  end

}

function M.RouteCollection:New()
  local o = {}
  self.__index = self
  o = setmetatable(o, self)
  o.Routes = setmetatable(o.Routes, routesMetatable)
  return o
end


function M.RouteCollection:AddRoute(path, func, type)
  local t = type
  if type == nil or type ~= 'pattern' then t = 'exact' end
  table.insert(self.Routes, {Path = path, Function = func, Type = t}
)
end


return M
