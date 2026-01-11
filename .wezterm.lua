-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.default_prog = { "zsh", "-c", " exec zsh" }

-- For example, changing the initial geometry for new windows:

config.window_decorations = "RESIZE"



-- or, changing the font size and color scheme.
config.font_size = 9
config.color_scheme = 'Breeze (Gogh)'
config.use_fancy_tab_bar = false
config.default_cursor_style = 'SteadyBlock'

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
config.front_end = "OpenGL"
config.webgpu_power_preference = "HighPerformance"


config.automatically_reload_config = true

config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = true

function get_max_cols(window)
    local tab = window:active_tab()
    local cols = tab:get_size().cols
    return cols
end

wezterm.on(
    'window-config-reloaded',
    function(window)
        wezterm.GLOBAL.cols = get_max_cols(window)
    end
)

wezterm.on(
    'window-resized',
    function(window, pane)
        wezterm.GLOBAL.cols = get_max_cols(window)
    end
)

local wezterm           = require 'wezterm'

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
    local title = ' ? '

    if pane.current_working_dir then
        local cwd = pane.current_working_dir.file_path or tostring(pane.current_working_dir)
        cwd = cwd:gsub('^file://', ''):gsub('/+$', '')
        title = cwd:match('([^/]+)$') or cwd
    end

    -- home → ~
    if title == wezterm.home_dir:match('([^/]+)$') then
        title = '~'
    end

    local index = tab.tab_index + 1
    local text = string.format('  %d  %s  ', index, title)

    -- truncate aman
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
        -- tab body
        { Background = { Color = bg } },
        { Foreground = { Color = fg } },
        { Text = text },

        -- powerline separator
        { Foreground = { Color = bg } },
        { Text = SOLID_RIGHT_ARROW },

    }
end)


if title == wezterm.home_dir:match('([^/]+)$') then
    title = '~'
end



-- The filled in variant of the < symbol
config.tab_max_width = 40



-- Finally, return the configuration to wezterm:
return config
