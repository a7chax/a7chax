-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

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
config.webgpu_power_preference="HighPerformance"


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

wezterm.on(
    'format-tab-title',
    function(tab)
        local pane = tab.active_pane
        local cwd_uri = pane.current_working_dir
        local title = '?'

        if cwd_uri then
            local cwd = cwd_uri.file_path or tostring(cwd_uri)
            cwd = cwd:gsub('^file://', '')
            cwd = cwd:gsub('/+$', '')
            title = cwd:match('([^/]+)$') or cwd
        end

        return {
            { Text = '  [' .. (tab.tab_index + 1) .. '] ' .. title .. '  ' },
        }
    end
)

if title == wezterm.home_dir:match('([^/]+)$') then
    title = '~'
end



-- The filled in variant of the < symbol
config.tab_max_width = 40



-- Finally, return the configuration to wezterm:
return config
