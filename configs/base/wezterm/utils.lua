local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

function M.array_merge(t1, t2)
  local result = {}
  for _, value in ipairs(t1) do table.insert(result, value) end
  for _, value in ipairs(t2) do table.insert(result, value) end
  return result
end

function M.get_cwd(pane)
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    return cwd_uri.file_path or tostring(cwd_uri)
  end
  return os.getenv("HOME")
end

local function get_existing_pane_ids(tab)
  local ids = {}
  for _, p in ipairs(tab:panes()) do
    ids[p:pane_id()] = true
  end
  return ids
end

local function find_new_pane(tab, existing_ids)
  for _, p in ipairs(tab:panes()) do
    if not existing_ids[p:pane_id()] then return p end
  end
  return nil
end

local function is_pane_exist(tab, pane_id)
  for _, p in ipairs(tab:panes()) do
    if p:pane_id() == pane_id then return true end
  end
  return false
end

function M.open_sidebar(window, pane, args, callback)
  local cwd = M.get_cwd(pane)
  local tab = window:active_tab()
  local existing_ids = get_existing_pane_ids(tab)

  window:perform_action(act.SplitPane {
    direction = 'Left',
    size = { Percent = 35 },
    command = { args = args, cwd = cwd },
  }, pane)

  local new_pane = find_new_pane(tab, existing_ids)
  if not new_pane then
    wezterm.log_error('[Sidebar] new pane not found after split')
    return
  end
  local new_pane_id = new_pane:pane_id()

  local function poll()
    local is_closed = not is_pane_exist(tab, new_pane_id)
    local is_done = callback(new_pane, is_closed)
    if is_closed or is_done then return end
    wezterm.time.call_after(0.5, poll)
  end
  poll()
end

return M
