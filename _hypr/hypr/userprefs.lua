-- User preferences

hl.env("GDK_SCALE", "1")

hl.config({
    xwayland = {
        force_zero_scaling = true
    }
})

-- Additional keybindings
make_bind({ MAIN_MOD, "period" }, "emote")
-- make_bind({ "SUPER", "ALT" }, "XF86MonBrightnessDown", "hlshade on blue-light-filter")
-- make_bind({ "SUPER", "ALT" }, "XF86MonBrightnessUp", "hlshade off")

-- Additional window rules
hl.window_rule({ match = { class = "^(Steam)$" }, opacity = "0.60 0.60" })
hl.window_rule({ match = { class = "^(steam)$" }, opacity = "0.60 0.60" })
hl.window_rule({ match = { class = "^(steamwebhelper)$" }, opacity = "0.60 0.60" })
hl.window_rule({ match = { class = "^(Spotify)$" }, opacity = "0.70 0.70" })
hl.window_rule({ match = { class = "^(Discord)$" }, opacity = "0.75 0.75" })
hl.window_rule({ match = { class = "^(discord)$" }, opacity = "0.75 0.75" })
hl.window_rule({ match = { class = "^(xwaylandvideobridge)$" }, opacity = "0.0 override 0.0 override" })
hl.window_rule({ match = { class = "^(xwaylandvideobridge)$" }, no_anim = true })
hl.window_rule({ match = { class = "^(xwaylandvideobridge)$" }, no_focus = true })
hl.window_rule({ match = { class = "^(xwaylandvideobridge)$" }, no_initial_focus = true })

-- Submap configuration
hl.define_submap("passtrhu", function()
    make_bind({ MAIN_MOD, "Escape" }, hl.dsp.submap("reset"))
end)

make_bind({ "CTRL", "Alt_L", "V" }, hl.dsp.submap("passtrhu"))
