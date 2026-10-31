---@class WorkspaceTelescope
---@field workspace Workspace
local Telescope = {}
Telescope.__index = Telescope

---@return WorkspaceTelescope
function Telescope:new()
    return setmetatable({
        workspace = require('workspace'),
    }, self)
end

---@param fn function
---@return function
function Telescope:with_cwd(fn)
    return function(fopts)
        fopts = fopts or {}

        if self.workspace:active() and not fopts.cwd then
            local active = self.workspace.list:get_active()
            fopts.cwd = active.path
            fopts.results_title = 'Workspace (' .. active.name .. ')'
        end

        return fn(fopts)
    end
end

return Telescope
