local M = {}

local function is_wezterm()
  return os.getenv("WEZTERM_PANE") ~= nil
end

local open_hovered = ya.sync(function(st)
  if not is_wezterm() then return end

	local hovered = cx.active.current.hovered
	if not hovered or not hovered.url then return end

	local filename = string.format("%s", hovered.url)
	local child, err = Command("wezterm")
		:arg { "cli", "spawn", "micro", filename }
		:stdout(Command.NULL)
		:spawn()

  if not child then
    ya.err("Failed to run command: " .. err)
  end
end)

function M:entry()
	open_hovered()
end

return M
