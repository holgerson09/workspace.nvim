---@class WorkspaceProfile
---@field name string
---@field path string

---@class WorkspaceList
---@field name string
---@field profiles WorkspaceProfile[]
---@field default integer
---@field active integer
local List = {}
List.__index = List

---@return WorkspaceList
function List:new()
    return setmetatable({}, self)
end

---@param data WorkspaceData
function List:update(data)
    local c = data.config
    if c then
        self.name = c.name
        self.profiles = c.profiles
        self.default = c.default
        self.active = self.default
    end
end

---@param index integer
---@return boolean
function List:select(index)
    local len = #self.profiles
    if index > len or index < 1 then
        return false
    end

    self.active = index

    return true
end

---@return WorkspaceProfile
function List:get_active()
    return self.profiles[self.active]
end

---@return string
function List:get_active_path()
    local cwd = assert(vim.uv.cwd(), "Could not get current working directory")
    return vim.fs.joinpath(cwd, self:get_active().path)
end

return List
