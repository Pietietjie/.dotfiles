-- lua/utils/logger.lua
local M = {}

local log_levels = {
  TRACE = 0,
  DEBUG = 1,
  INFO = 2,
  WARN = 3,
  ERROR = 4,
}

-- Default log level, change this to control what gets logged
local current_log_level = log_levels.INFO

-- Helper to pretty-print tables
local function dump_table(obj)
  local seen = {}
  local function dump_recursive(o, indent)
    if type(o) == "number" or type(o) == "string" or type(o) == "boolean" then
      return tostring(o)
    elseif type(o) == "nil" then
      return "nil"
    elseif type(o) == "function" then
      return "function: " .. tostring(o)
    elseif type(o) == "table" then
      if seen[o] then
        return "{...}" -- Avoid infinite recursion
      end
      seen[o] = true
      local s = "{\n"
      for k, v in pairs(o) do
        local key_str
        if type(k) == "string" then
          key_str = string.format('"%s"', k)
        else
          key_str = tostring(k)
        end
        s = s .. indent .. "  " .. key_str .. " = " .. dump_recursive(v, indent .. "  ") .. ",\n"
      end
      s = s .. indent .. "}"
      seen[o] = nil -- Allow re-dumping if needed elsewhere
      return s
    else
      return tostring(o)
    end
  end
  return dump_recursive(obj, "")
end

local function _log(level, ...)
  if log_levels[level] < current_log_level then
    return
  end

  local args = { ... }
  local formatted_args = {}

  for _, arg in ipairs(args) do
    if type(arg) == "table" then
      table.insert(formatted_args, dump_table(arg))
    else
      table.insert(formatted_args, tostring(arg))
    end
  end

  local msg = table.concat(formatted_args, " ")
  vim.notify(msg, vim.log.levels[level])
  vim.api.nvim_echo({ { string.format("[%s] %s", level, msg) , "" } }, true, {verbose = true})
end

--- Sets the global log level.
-- @param level string The log level (e.g., "INFO", "DEBUG", "TRACE", "WARN", "ERROR")
function M.set_log_level(level)
  local upper_level = string.upper(level)
  if log_levels[upper_level] then
    current_log_level = log_levels[upper_level]
    _log("INFO", "Log level set to:", upper_level)
  else
    _log("WARN", "Invalid log level provided:", level)
  end
end

-- Exported logging functions
function M.trace(...)
  _log("TRACE", ...)
end

function M.debug(...)
  _log("DEBUG", ...)
end

function M.info(...)
  _log("INFO", ...)
end

function M.warn(...)
  _log("WARN", ...)
end

function M.error(...)
  _log("ERROR", ...)
end

return M
