local AuGroup = require('workspace.augroup')
local Data = require('workspace.data')
local List = require('workspace.list')

---@class Workspace
---@field data WorkspaceData
---@field list WorkspaceList
local Workspace = {}
Workspace.__index = Workspace

---@return Workspace
function Workspace:new()
    local workspace = setmetatable({
        data = Data:new(),
        list = List:new(),
    }, self)

    return workspace
end

local the_workspace = Workspace:new()

function Workspace:setup()
    vim.api.nvim_create_autocmd('DirChanged', {
        group = AuGroup,
        callback = function()
            self:check()
        end,
    })

    self:check()
end

function Workspace:check()
    local err = self.data:load()
    if err then
        vim.notify(err, vim.log.levels.ERROR)
    end

    self.list:update(self.data)
    if self.data.config then
        vim.notify("Workspace loaded", vim.log.levels.INFO)
    end
end

---@return boolean
function Workspace:active()
    return self.data.config ~= nil
end

return the_workspace
