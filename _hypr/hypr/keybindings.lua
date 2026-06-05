-- Keybindings configuration

MAIN_MOD = 'SUPER'

-- Variables for applications
local term = 'wezterm'
local file_manager = 'thunar'
local firefox = 'firefox-developer-edition'

function make_bind(keys, exe_or_dispatcher)
    local closure = exe_or_dispatcher
    if type(exe_or_dispatcher) == 'string' then
        closure = hl.dsp.exec_cmd(exe_or_dispatcher)
    end

    hl.bind(table.concat(keys, ' + '), closure)
end

-- Window/Session actions
make_bind({ MAIN_MOD, 'M' }, 'hyprlock')
make_bind({ MAIN_MOD, 'backspace' }, '~/.config/hypr/scripts/logoutlaunch.sh 1')
make_bind({ 'CONTROL', 'ESCAPE' }, 'killall waybar || waybar')

make_bind({ MAIN_MOD, 'Q' }, hl.dsp.window.close())
make_bind({ 'ALT', 'F4' }, hl.dsp.window.kill())
make_bind({ MAIN_MOD, 'delete' }, hl.dsp.exit()) -- TODO: Migrate to `hyprshutdown`
make_bind({ MAIN_MOD, 'W' }, hl.dsp.window.float())
make_bind({ MAIN_MOD, 'G' }, hl.dsp.group.toggle())
make_bind({ 'ALT', 'return' }, hl.dsp.window.fullscreen())

-- Application shortcuts
make_bind({ MAIN_MOD, 'T' }, term)
make_bind({ MAIN_MOD, 'E' }, file_manager)
make_bind({ MAIN_MOD, 'F' }, firefox)
make_bind({ 'CONTROL', 'SHIFT', 'ESCAPE' }, '~/.config/hypr/scripts/sysmonlaunch.sh')

-- Rofi bindings
make_bind({ MAIN_MOD, 'space' }, 'pkill -x rofi || ~/.config/hypr/scripts/rofilaunch.sh d')
make_bind({ MAIN_MOD, 'tab' }, 'pkill -x rofi || ~/.config/hypr/scripts/rofilaunch.sh w')
make_bind({ MAIN_MOD, 'R' }, 'pkill -x rofi || ~/.config/hypr/scripts/rofilaunch.sh f')

-- Audio control
make_bind({ 'XF86AudioMute' }, '~/.config/hypr/scripts/volumecontrol.sh -o m')
make_bind({ 'XF86AudioMicMute' }, '~/.config/hypr/scripts/volumecontrol.sh -i m')
make_bind({ 'XF86AudioLowerVolume' }, '~/.config/hypr/scripts/volumecontrol.sh -o d')
make_bind({ 'XF86AudioRaiseVolume' }, '~/.config/hypr/scripts/volumecontrol.sh -o i')
make_bind({ 'XF86AudioPlay' }, 'playerctl play-pause')
make_bind({ 'XF86AudioPause' }, 'playerctl play-pause')
make_bind({ 'XF86AudioNext' }, 'playerctl next')
make_bind({ 'XF86AudioPrev' }, 'playerctl previous')

-- Brightness control
make_bind({ 'XF86MonBrightnessUp' }, '~/.config/hypr/scripts/brightnesscontrol.sh i')
make_bind({ 'XF86MonBrightnessDown' }, '~/.config/hypr/scripts/brightnesscontrol.sh d')

-- Screenshot/Screencapture
make_bind({ MAIN_MOD, 'P' }, '~/.config/hypr/scripts/screenshot.sh s')
make_bind({ MAIN_MOD, 'ALT', 'P' }, '~/.config/hypr/scripts/screenshot.sh m')
make_bind({ 'print' }, '~/.config/hypr/scripts/screenshot.sh p')

-- FIXME
-- Exec custom scripts
make_bind({ MAIN_MOD, 'ALT', 'G' }, '~/.config/hypr/scripts/gamemode.sh')
make_bind({ MAIN_MOD, 'ALT', 'right' }, '~/.config/hypr/scripts/swwwallpaper.sh -n')
make_bind({ MAIN_MOD, 'ALT', 'left' }, '~/.config/hypr/scripts/swwwallpaper.sh -p')
make_bind({ MAIN_MOD, 'ALT', 'up' }, '~/.config/hypr/scripts/wbarconfgen.sh n')
make_bind({ MAIN_MOD, 'ALT', 'down' }, '~/.config/hypr/scripts/wbarconfgen.sh p')
make_bind({ MAIN_MOD, 'SHIFT', 'D' }, '~/.config/hypr/scripts/wallbashtoggle.sh')
make_bind({ MAIN_MOD, 'SHIFT', 'T' }, 'pkill -x rofi || ~/.config/hypr/scripts/themeselect.sh')
make_bind({ MAIN_MOD, 'SHIFT', 'A' }, 'pkill -x rofi || ~/.config/hypr/scripts/rofiselect.sh')
make_bind({ MAIN_MOD, 'SHIFT', 'W' }, 'pkill -x rofi || ~/.config/hypr/scripts/swwwallselect.sh')
make_bind({ MAIN_MOD, 'V' }, 'pkill -x rofi || ~/.config/hypr/scripts/cliphist.sh c')
make_bind({ MAIN_MOD, 'Y' }, '~/.config/hypr/scripts/keyboardswitch.sh')

-- Move focus with mainMod + arrow keys
make_bind({ MAIN_MOD, 'h' }, hl.dsp.focus({ direction = 'l' }))
make_bind({ MAIN_MOD, 'l' }, hl.dsp.focus({ direction = 'r' }))
make_bind({ MAIN_MOD, 'k' }, hl.dsp.focus({ direction = 'u' }))
make_bind({ MAIN_MOD, 'j' }, hl.dsp.focus({ direction = 'd' }))
make_bind({ 'ALT', 'Tab' }, hl.dsp.focus({ direction = 'd' }))

-- Switch workspaces with mainMod + CTRL + [←→]
make_bind({ MAIN_MOD, 'CTRL', 'right' }, hl.dsp.focus({ workspace = 'r+1' }))
make_bind({ MAIN_MOD, 'CTRL', 'left' }, hl.dsp.focus({ workspace = 'r-1' }))
make_bind({ MAIN_MOD, 'CTRL', 'l' }, hl.dsp.focus({ workspace = 'r+1' }))
make_bind({ MAIN_MOD, 'CTRL', 'h' }, hl.dsp.focus({ workspace = 'r-1' }))

-- Move to the first empty workspace
make_bind({ MAIN_MOD, 'CTRL', 'down' }, hl.dsp.focus({ workspace = 'empty' }))
make_bind({ MAIN_MOD, 'CTRL', 'j' }, hl.dsp.focus({ workspace = 'empty' }))

-- Resize windows
make_bind({ MAIN_MOD, 'SHIFT', 'l' }, hl.dsp.window.resize({ relative = true, x = 20, y = 0 }))
make_bind({ MAIN_MOD, 'SHIFT', 'h' }, hl.dsp.window.resize({ relative = true, x = -20, y = 0 }))
make_bind({ MAIN_MOD, 'SHIFT', 'k' }, hl.dsp.window.resize({ relative = true, x = 0, y = -20 }))
make_bind({ MAIN_MOD, 'SHIFT', 'j' }, hl.dsp.window.resize({ relative = true, x = 0, y = 20 }))

-- Move active window to a relative workspace
make_bind({ MAIN_MOD, 'CTRL', 'ALT', 'right' }, hl.dsp.window.move({ workspace = 'r+1' }))
make_bind({ MAIN_MOD, 'CTRL', 'ALT', 'left' }, hl.dsp.window.move({ workspace = 'r-1' }))
make_bind({ MAIN_MOD, 'CTRL', 'ALT', 'l' }, hl.dsp.window.move({ workspace = 'r+1' }))
make_bind({ MAIN_MOD, 'CTRL', 'ALT', 'h' }, hl.dsp.window.move({ workspace = 'r-1' }))

-- Move active window around current workspace
make_bind({ MAIN_MOD, 'SHIFT', 'CONTROL', 'left' }, hl.dsp.window.move({ direction = 'l' }))
make_bind({ MAIN_MOD, 'SHIFT', 'CONTROL', 'right' }, hl.dsp.window.move({ direction = 'r' }))
make_bind({ MAIN_MOD, 'SHIFT', 'CONTROL', 'up' }, hl.dsp.window.move({ direction = 'u' }))
make_bind({ MAIN_MOD, 'SHIFT', 'CONTROL', 'down' }, hl.dsp.window.move({ direction = 'd' }))

-- TODO: Does this even work and is it useful ?
-- Scroll through existing workspaces
make_bind({ MAIN_MOD, 'mouse_down' }, hl.dsp.focus({ workspace = 'r+1' }))
make_bind({ MAIN_MOD, 'mouse_up' }, hl.dsp.focus({ workspace = 'r-1' }))

-- Move/Resize windows with mainMod,+ LMB/RMB
make_bind({ MAIN_MOD, 'mouse:272' }, hl.dsp.window.drag())
make_bind({ MAIN_MOD, 'mouse:273' }, hl.dsp.window.resize())

-- Special workspaces (scratchpad)
make_bind({ MAIN_MOD, 'ALT', 'S' }, hl.dsp.window.move({ workspace = 'special:magic' }))
make_bind({ MAIN_MOD, 'S' }, hl.dsp.workspace.toggle_special())

-- Toggle Layout
make_bind({ MAIN_MOD, 'B' }, hl.dsp.layout('togglesplit'))

-- Trigger when the switch is turning off
make_bind({ 'switch:on:Lid Switch' }, 'swaylock && systemctl suspend')
