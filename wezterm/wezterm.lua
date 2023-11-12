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

local font_fam = osname == 'Windows' and 'MesloLGS NFM' or 'MesloLGS NF'

local function getBGPath()
    local switch = {
        ["Windows"] = [[e:/Steam/userdata/234096917/760/remote/1250410/screenshots/wallpapers]],
        ["Linux"] = "/home/snoupix/wallpapers",
        ["MacOS"] = "/Users/snoupix/wallpapers",
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
    -- 'MesloLGMDZNerdFont',
    'MesloLGMDZNerdFontMono',
    'MesloLGS-Regular',
    'JetBrainsMono',
    'JetBrainsMonoNerdFont',
    font_fam,
    'monospace',
}

config.font_size = 10.0

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

config.enable_tab_bar = false

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
    opacity = osname == "Linux" and 0.4 or 0.85,
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
elseif osname == "Linux" then
    config.default_cwd = getHome() .. '/work'
end

return config
