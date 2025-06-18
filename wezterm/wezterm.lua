local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

local default_bg = "20230328173918_1.jpg"
local osname = 'Windows' -- Windows, Linux or MacOS

local separator = package.config:sub(1, 1)
if separator == '/' then
    local uname = io.popen("uname -s"):read("*l")
    if uname == "Linux" then
        osname = 'Linux'
    elseif uname == "Darwin" then
        osname = 'MacOS'
    end
elseif separator == '\\' then
    osname = 'Windows'
end

local function getHome()
    return os.getenv("HOME") or os.getenv("USERPROFILE") or "/home/snoupix"
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
if osname == "Linux" then
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
elseif osname == "MacOS" then
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

    return switch[osname]
end

local function getRandomBGorDefault(directory, default_bg)
    local files = {}
    local pfile = io.popen('dir "' .. directory .. '" /b')
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

config.font_size = osname == "Linux" and 15.0 or osname == "MacOS" and 10.5 or 10.0

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
    top = 10,
    bottom = 10,
}

if config.background == nil then
    config.background = {}
end

if osname ~= "Linux" then
    table.insert(config.background, {
        source = {
            File = getRandomBGorDefault(
                getBGPath(),
                getBGPath() .. '/' .. default_bg
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
    opacity = osname == "Linux" and 0.2 or 0.85,
    hsb = {
        brightness = 1.0,
        hue = 1.0,
        saturation = 1.0,
    },
    height = '100%',
    width = '100%',
})

if osname == "Windows" then
    config.default_prog = {
        'C:\\Windows\\System32\\wsl.exe',
        '-d',
        'Arch',
    }

    config.default_cwd = [[\\wsl$\Arch\home\snoupix\work]]
elseif osname == "MacOS" then
    config.native_macos_fullscreen_mode = true
    config.default_cwd = getHome() .. '/work'
elseif osname == "Linux" then
    config.default_cwd = getHome() .. '/work'
end

config.enable_wayland = false

return config
