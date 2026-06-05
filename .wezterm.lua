-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.default_prog = { '/bin/zsh' }

if wezterm.target_triple:find("apple%-darwin") then
    -- macOS GUI apps can start without the shell PATH; call zellij directly.
    config.default_prog = { '/bin/zsh', '-lc', '$HOME/.cargo/bin/zellij attach default -c; exec /bin/zsh -l' }
  else
    -- non-macOS: WezTerm owns the zellij auto-start, not zsh itself.
    config.default_prog = { '/bin/zsh', '-ic', 'zellij attach default -c' }
  end
  -- For example, changing the initial geometry for new windows:

if wezterm.target_triple:find("apple%-darwin") then
    config.window_decorations = "RESIZE"
    config.font_size = 10
else
    config.window_decorations = "NONE"
    config.font_size = 9
end

config.font = wezterm.font_with_fallback {
    'JetBrains Mono',
    'Apple Color Emoji',
    'Noto Color Emoji',
}

config.color_scheme = 'Breeze (Gogh)'
config.default_cursor_style = 'SteadyBlock'
config.enable_tab_bar = false

config.visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 150,
    fade_out_function = 'EaseOut',
    fade_out_duration_ms = 150,
}
config.colors = {
    visual_bell = '#202020',
}

config.notification_handling = 'AlwaysShow'
config.scrollback_lines = 1000
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"


config.automatically_reload_config = true


local act = wezterm.action


local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- Colors (sesuaikan theme kamu)
local ACTIVE_BG         = '#268bd2'
local ACTIVE_FG         = '#ffffff'
local INACTIVE_BG       = '#1e1e1e'
local INACTIVE_FG       = '#9aa0a6'
local HOVER_BG          = '#2a2a2a'
local HOVER_FG          = '#ffffff'

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local title = tab.tab_title

    -- if no custom title, use cwd folder name
    if not title or #title == 0 then
        title = ' ? '

        if pane.current_working_dir then
            local cwd = pane.current_working_dir.file_path or tostring(pane.current_working_dir)
            cwd = cwd:gsub('^file://', ''):gsub('/+$', '')
            title = cwd:match('([^/]+)$') or cwd
        end


    end

    local index = tab.tab_index + 1
    local text = string.format('  %d  %s  ', index, title)

    if #text > max_width then
        text = wezterm.truncate_right(text, max_width - 2) .. '… '
    end

    local bg, fg
    if tab.is_active then
        bg = ACTIVE_BG
        fg = ACTIVE_FG
    elseif hover then
        bg = HOVER_BG
        fg = HOVER_FG
    else
        bg = INACTIVE_BG
        fg = INACTIVE_FG
    end

    return {
        { Background = { Color = bg } },
        { Foreground = { Color = fg } },
        { Text = text },
        { Foreground = { Color = bg } },
        { Text = SOLID_RIGHT_ARROW },
    }
end)


if title == wezterm.home_dir:match('([^/]+)$') then
    title = '~'
end

config.keys = {
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- Disable vertical splitting
  {
    key = '"',
    mods = 'ALT|CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = '"',
    mods = 'SHIFT|ALT|CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = '\'',
    mods = 'SHIFT|ALT|CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- Disable horizontal splitting
  {
    key = '%',
    mods = 'ALT|CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = '%',
    mods = 'SHIFT|ALT|CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = '5',
    mods = 'SHIFT|ALT|CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- Disable spawning new window
  {
    key = 'n',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'N',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'N',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'n',
    mods = 'SUPER',
    action = wezterm.action.DisableDefaultAssignment,
  },
}

if wezterm.target_triple:find("apple%-darwin") then
  local mac_key_disables = {
    -- Disable spawning new tab
    {
      key = 't',
      mods = 'CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = 'T',
      mods = 'CMD|SHIFT',
      action = wezterm.action.DisableDefaultAssignment,
    },
    -- Disable vertical splitting
    {
      key = '"',
      mods = 'OPT|CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = '"',
      mods = 'SHIFT|OPT|CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = '\'',
      mods = 'SHIFT|OPT|CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    -- Disable horizontal splitting
    {
      key = '%',
      mods = 'OPT|CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = '%',
      mods = 'SHIFT|OPT|CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = '5',
      mods = 'SHIFT|OPT|CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    -- Disable spawning new window
    {
      key = 'n',
      mods = 'CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = 'n',
      mods = 'SHIFT|CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = 'N',
      mods = 'SHIFT|CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = 'N',
      mods = 'CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
  }

  for _, key in ipairs(mac_key_disables) do
    table.insert(config.keys, key)
  end
end

-- Finally, return the configuration to wezterm:
return config
