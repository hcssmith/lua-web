M = {}

function M.Switch(value, actions)
  return actions[value]()
end

return M
