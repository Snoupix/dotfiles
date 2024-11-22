local wezterm = require 'wezterm'

local config = {}
config.adjust_window_size_when_changing_font_size = false

if wezterm.config_builder then
    config = wezterm.config_builder()
end

local default_bg_name = "20230328173918_1.jpg"
local os_name = 'Windows' -- Windows, Linux or MacOS

local separator = package.config:sub(1, 1)
if separator == '/' then
    local uname = io.popen("uname -s"):read("*l")
    if uname == "Linux" then
        os_name = 'Linux'
    elseif uname == "Darwin" then
        os_name = 'MacOS'
    end
elseif separator == '\\' then
    os_name = 'Windows'
end

local function get_home()
    return os.getenv("HOME") or os.getenv("USERPROFILE") or "/home/snoupix"
end

local function is_work_os()
    local file_path = "/etc/lsb-release"
    if os_name ~= "Linux" then
        return false
    end

    local os_file = io.open(file_path, "r")
    if os_file == nil then
        wezterm.log_warn(file_path .. " file not found to retrieve OS distro")
        return false
    end

    local content = os_file:read("a")
    os_file:close()

    -- find method returns either the index or nil
    return content:lower():find("distrib_id=pop") ~= nil
end

local font_fam = { 'MesloLGS NFM' } -- Windows
local harfbuzz_features = {         -- https://github.com/githubnext/monaspace#coding-ligatures
    "calt=1",
    "dlig=1",
    "clig=1",
    "liga=1",
    "kern=1",
    "mark=1",
    "mkmk=1",
    "rclt=1",
    "rlig=1",
    "curs=1",
    "kern=1",
    "mark=1",
    "mkmk=1",
    "rclt=1",
    "rlig=1",
    "curs=1",
    "ss01=1",
    "ss02=1",
    "ss03=1",
    "ss04=1",
    "ss05=1",
    "ss06=0",
    "ss07=1",
    "ss08=1"
}
if os_name == "Linux" then
    font_fam = {
        -- 'MesloLGMDZNerdFont',
        -- 'MonaspaceArgon-Light',
        -- 'MonaspaceXenon-Light',
        {
            family = 'MonaspaceNeon-Regular',
            harfbuzz_features = harfbuzz_features,
        },
        'MesloLGMDZNerdFontMono',
        'MesloLGS-Regular',
        'JetBrainsMono',
        'JetBrainsMonoNerdFont',
    }
elseif os_name == "MacOS" then
    font_fam = {
        {
            family = 'Monaspace Neon',
            harfbuzz_features = harfbuzz_features,
        },
        'MesloLGS NF',
        'JetBrainsMono',
        'JetBrainsMonoNerdFont',
    }
end

local function getBGPath()
    local switch = {
        ["Windows"] = [[e:/Steam/userdata/234096917/760/remote/1250410/screenshots/wallpapers]],
        ["Linux"] = "/home/snoupix/wallpapers",
        ["MacOS"] = "/Users/admin/Pictures/wallpapers",
    }

    return switch[os_name]
end

local function getRandomBGorDefault(directory, default_bg)
    local files = {}
    local pfile = io.popen('dir "' .. directory .. '" /b')

    if pfile == nil then
        return default_bg
    end

    local result = pfile:read('*a')

    pfile:close()

    for line in result:gmatch("[^\r\n]+") do
        table.insert(files, line)
    end

    -- wezterm.log_info('Found '..#files..' files in '..directory)

    if #files == 0 then
        return default_bg
    end

    return directory .. '/' .. files[math.random(#files)]
end

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.font = wezterm.font_with_fallback {
    table.unpack(font_fam),
    'monospace',
}

config.font_size = os_name == "Linux" and 10.5 or os_name == "MacOS" and 10.5 or 10.0

-- TODO: https://wezfurlong.org/wezterm/config/appearance.html#tab-bar-appearance-colors
config.colors = {
    foreground = '#EBDDF4',
    background = '#010B17',

    cursor_fg = '#FFFFFF',
    cursor_bg = '#0B3B61',

    ansi = {
        '#0B3B61',
        '#E02020',
        '#42CCA6',
        '#FFF383',
        '#5009CC',
        '#8892EA',
        '#FF5DD4',
        '#15FCA2'
    },

    brights = {
        '#62686C',
        '#FF54B0',
        '#73FFD8',
        '#FCF4AD',
        '#378DFE',
        '#AE81FF',
        '#2DDFD4',
        '#5FFBBE'
    },
}

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
-- config.show_close_button_in_tabs = false -- Night build only
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.switch_to_last_active_tab_when_closing_tab = true

config.window_padding = {
    left = 5,
    right = 5,
    top = 8,
    bottom = 8,
}

if config.background == nil then
    config.background = {}
end

if os_name ~= "Linux" then
    table.insert(config.background, {
        source = {
            File = getRandomBGorDefault(
                getBGPath(),
                getBGPath() .. '/' .. default_bg_name
            ),
        },
        opacity = 1.0,
        hsb = {
            brightness = 0.5, -- 0.04,
            hue = 1.0,
            saturation = 1.0,
        },
        height = '100%',
        width = '100%',
    })
end

table.insert(config.background, {
    source = {
        Color = '#010B17',
    },
    opacity = os_name == "Linux" and (is_work_os() and 0.8 or 0.2) or 0.85,
    hsb = {
        brightness = 1.0,
        hue = 1.0,
        saturation = 1.0,
    },
    height = '100%',
    width = '100%',
})

if os_name == "Windows" then
    config.default_prog = {
        'C:\\Windows\\System32\\wsl.exe',
        '-d',
        'Arch',
    }

    config.default_cwd = [[\\wsl$\Arch\home\snoupix\work]]
elseif os_name == "MacOS" then
    config.native_macos_fullscreen_mode = true
    config.default_cwd = get_home() .. '/work'
elseif os_name == "Linux" then
    config.default_cwd = get_home() .. '/work'
end

config.enable_wayland = is_work_os()

return config
