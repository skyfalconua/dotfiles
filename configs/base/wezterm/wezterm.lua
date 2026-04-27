local wezterm = require 'wezterm'
local act     = wezterm.action
local utils   = require "utils"

-- Base config -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'PaulMillr'
config.colors       = {
  cursor_bg     = '#ffffff',
  cursor_border = '#ffffff',
  split         = '#555555',
}
config.default_cursor_style  = 'BlinkingBar'
config.cursor_blink_ease_in  = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_thickness      = "2px"

config.font          =
    wezterm.font_with_fallback { 'Cascadia Code NF', 'JetBrains Mono' }
config.font_size     = 18

config.max_fps       = 120
config.animation_fps = 120

config.window_frame = {
  border_left_width = '0',
  border_right_width = '0',
  border_bottom_height = '0',
  border_top_height = '0',
}

-- Tab bar -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - -

config.quit_when_all_windows_are_closed = true
config.hide_tab_bar_if_only_one_tab     = false
config.tab_bar_at_bottom                = false
config.use_fancy_tab_bar                = false

local function tab_title(tab_info)
  local title = tab_info.tab_title or ''
  if #title > 0 then return title end

  title = tab_info.active_pane.title or ''
  if #title > 0 then return title end

  local process = tab_info.active_pane.foreground_process_name
	title =	process and wezterm.basename(process) or ''
  title = title or os.getenv('SHELL') or ('tab ' .. tab_info.tab_index)

  return title
end

wezterm.on(
  'format-tab-title',
  function(tab)
    local is_ssh = tab.active_pane.domain_name:match('^SSH:')

    local background = '#5F87AF'
    local foreground = '#000000'
    if tab.is_active then
      background = '#005F00'
      foreground = '#FFFFFF'
    end

    local edge_background = '#444444'
    local edge_foreground = '#FFFFFF'

    local title_prefix = ' '
    if tab.is_active then
      title_prefix = '❱ '
    end
    local title_postfix = ' '
    if is_ssh then
      title_postfix = '⋄'
    end
    local title = title_prefix .. tab_title(tab) .. title_postfix

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = ' ' },

      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },

      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = '' },
    }
  end
)

wezterm.on(
  'update-status',
  function(window)
    window:set_left_status(wezterm.format {
      { Text = ' ⛋  ' },
    })
    window:set_right_status(wezterm.format {
      { Text = ' | ' .. wezterm.hostname() .. ' ' },
    })
  end
)

-- Custom Actions -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local SidebarYazi = wezterm.action_callback(function(window, pane)
  local initial_cwd = utils.get_cwd(pane)
  local last_cwd = initial_cwd
  local args = { os.getenv('SHELL') or '/bin/zsh', '-lc', 'yazi' }

  utils.open_sidebar(window, pane, args, function(new_pane, is_closed)
    if is_closed then
      if last_cwd ~= initial_cwd then
        pane:send_text("  cd '" .. last_cwd:gsub("'", "\\'") .. "'\n")
      end
      return
    end
    last_cwd = utils.get_cwd(new_pane)
  end)
end)

local RenameTab = act.PromptInputLine {
  description = 'Enter new name for tab:',
  action = wezterm.action_callback(function(window, pane, line)
    if line then
      window:active_tab():set_title(line)
    end
  end),
}

-- Key bindings -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

local SplitPaneDown = act.SplitVertical    -- Add horizontal (bottom) split
local SplitPaneRight = act.SplitHorizontal -- Add vertical (right) split

local base_keys = {
  -- Unbind / disable defaults
  { key = 'w', mods = 'CMD',            action = act.DisableDefaultAssignment },
  { key = 'q', mods = 'CMD',            action = act.DisableDefaultAssignment },
  { key = 'h', mods = 'CMD',            action = act.DisableDefaultAssignment },
  { key = 'h', mods = 'CTRL|SHIFT',     action = act.DisableDefaultAssignment },
  { key = 'r', mods = 'CMD',            action = act.DisableDefaultAssignment },

  -- Native WezTerm actions
  { key = 'n', mods = 'CMD|SHIFT',      action = act.SpawnWindow },

  -- Add vertical (right) split
  { key = '"', mods = 'CTRL|ALT|SHIFT', action = act.DisableDefaultAssignment },
  { key = "'", mods = 'CTRL|ALT|SHIFT', action = act.DisableDefaultAssignment },
  { key = '"', mods = 'CTRL|ALT',       action = act.DisableDefaultAssignment },

  -- Add horizontal (bottom) split
  { key = '%', mods = 'CTRL|ALT|SHIFT', action = act.DisableDefaultAssignment },
  { key = '5', mods = 'CTRL|ALT|SHIFT', action = act.DisableDefaultAssignment },
  { key = '%', mods = 'CTRL|ALT',       action = act.DisableDefaultAssignment },
}

-- tmux passthrough (Ctrl-B = \x02 prefix)
local tmux_keys = {
  { key = 't',          mods = 'CMD',        action = act.SendString '\x02t' }, -- new tmux window
  { key = 'w',          mods = 'CTRL|SHIFT', action = act.SendString '\x02w' }, -- close surface
  { key = 'q',          mods = 'CTRL|SHIFT', action = act.SendString '\x02q' }, -- close tab/session
  { key = 'h',          mods = 'CMD|SHIFT',  action = act.SendString '\x02h' }, -- horizontal split
  { key = 'v',          mods = 'CMD|SHIFT',  action = act.SendString '\x02v' }, -- vertical split
  { key = '.',          mods = 'CMD',        action = act.SendString '\x02.' }, -- move tab to index
  { key = ',',          mods = 'CMD',        action = act.SendString '\x02,' }, -- rename tab
  { key = 'LeftArrow',  mods = 'CMD',        action = act.SendString '\x02p' }, -- prev tab
  { key = 'RightArrow', mods = 'CMD',        action = act.SendString '\x02n' }, -- next tab
  { key = '[',          mods = 'CMD',        action = act.SendString '\x02[' }, -- next tab
  { key = ']',          mods = 'CMD',        action = act.SendString '\x02]' }, -- next tab
}

local native_keys = {
  { key = 't',          mods = 'CMD',        action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w',          mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = false } },
  { key = 'q',          mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = false } },
  { key = 'h',          mods = 'CMD|SHIFT',  action = SplitPaneDown },
  { key = 'v',          mods = 'CMD|SHIFT',  action = SplitPaneRight },
  { key = 'y',          mods = 'CMD|SHIFT',  action = SidebarYazi },
  { key = ',',          mods = 'CMD',        action = RenameTab },
  { key = 'LeftArrow',  mods = 'CMD',        action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CMD',        action = act.ActivateTabRelative(1) },
  { key = '[',          mods = 'CMD',        action = act.MoveTabRelative(-1) },
  { key = ']',          mods = 'CMD',        action = act.MoveTabRelative(1) },
}

config.keys = utils.array_merge(base_keys, native_keys)
-- config.keys = array_merge(base_keys, tmux_keys)

return config
