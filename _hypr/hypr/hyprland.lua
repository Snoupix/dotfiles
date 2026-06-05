-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

-- Debug settings
-- hl.debug({
--     disable_logs = false,
--     enable_stdout_logs = true
-- })

-- Monitor configuration
hl.monitor({ output = 'eDP-1', mode = '1920x1080@60', position = '0x0', scale = 1 })
hl.monitor({ output = '', mode = 'preferred', position = 'auto', scale = 'auto', mirror = 'eDP-1' })

-- Environment variables
hl.env('XDG_CURRENT_DESKTOP', 'Hyprland')
hl.env('XDG_SESSION_TYPE', 'wayland')
hl.env('XDG_SESSION_DESKTOP', 'Hyprland')
hl.env('GDK_BACKEND', 'wayland')
hl.env('QT_QPA_PLATFORM', 'wayland')
hl.env('QT_QPA_PLATFORMTHEME', 'qt5ct')
hl.env('QT_WAYLAND_DISABLE_WINDOWDECORATION', '1')
hl.env('QT_AUTO_SCREEN_SCALE_FACTOR', '1')
hl.env('MOZ_ENABLE_WAYLAND', '1')

-- Execute commands on startup
hl.on('hyprland.start', function()
    hl.exec_cmd('~/.config/hl/scripts/resetxdgportal.sh')
    hl.exec_cmd('dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP')
    hl.exec_cmd('dbus-update-activation-environment --systemd --all')
    hl.exec_cmd('systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP')
    hl.exec_cmd('/usr/lib/polkit-kde-authentication-agent-1')
    hl.exec_cmd('waybar')
    hl.exec_cmd('blueman-applet')
    hl.exec_cmd('nm-applet --indicator')
    hl.exec_cmd('dunst')
    hl.exec_cmd('wl-paste --type text --watch cliphist store')
    hl.exec_cmd('wl-paste --type image --watch cliphist store')
    hl.exec_cmd('~/.config/hl/scripts/swwwallpaper.sh')
    hl.exec_cmd('~/.config/hl/scripts/batterynotify.sh')
end)

hl.config({
    -- Input configuration
    input = {
        kb_layout = 'fr',
        kb_options = 'caps:swapescape',
        follow_mouse = true,
        touchpad = { natural_scroll = true },
        sensitivity = -0.1,
        force_no_accel = true
    },

    -- Dwindle layout configuration
    dwindle = {
        preserve_split = true
    },

    -- Master layout configuration
    master = {
        new_status = 'master',
        orientation = 'right'
    },

    -- Miscellaneous settings
    misc = {
        vrr = 0,
        force_default_wallpaper = 0
    },
})

-- Device specific configuration
hl.device({
    name = 'foostan-corne',
    kb_layout = 'us,fr'
})

-- Gesture configuration
hl.gesture({
    fingers = 3,
    direction = 'horizontal',
    action = 'workspace'
})

-- Import other configuration files
require('animations')
require('keybindings')
require('windowrules')
require('themes.common')
require('themes.theme')
require('themes.colors')
require('monitors')
require('userprefs')
