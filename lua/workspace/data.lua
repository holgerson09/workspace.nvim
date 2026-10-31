---@return string[]?
local function read_file()
    local path = vim.uv.cwd() .. '/.nvim/workspace.json'
    if vim.fn.filereadable(path) == 0 then
        return
    end
    return vim.fn.readfile(path)
end

---@param lines string[]
---@return table? data
---@return string? err
local function parse_json(lines)
    local content = table.concat(lines, '\n')
    local ok, data = pcall(vim.json.decode, content)

    if not ok then
        return nil, ('Invalid JSON: %s'):format(data)
    end

    if type(data) ~= 'table' then
        return nil, 'Workspace JSON must contain a table'
    end

    return data
end

---@class WorkspaceData
---@field config table?
local WorkspaceData = {}
WorkspaceData.__index = WorkspaceData

---@return WorkspaceData
function WorkspaceData:new()
    return setmetatable({
        config = nil,
    }, self)
end

---@return string? err
function WorkspaceData:load()
    local lines = read_file()
    if not lines then
        return
    end

    local data, err = parse_json(lines)
    if err then
        return err
    end

    self.config = data
end

return WorkspaceData
