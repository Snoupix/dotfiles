-- Theme specific settings

hl.dsp.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-green'")
hl.dsp.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Decay-Green'")
hl.dsp.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

hl.config({
    general = {
        -- workspace = "n[false]", -- not nammed workspace (trick to target everything)
        gaps_in = 3,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(90ceaaff)", "rgba(ecd3a0ff)" }, angle = 45 },
            inactive_border = { colors = { "rgba(86aaeccc)", "rgba(93cee9cc)" }, angle = 45 },
        },
        layout = "dwindle",
        resize_on_border = true
    },

    decoration = {
        rounding = 10,
        shadow = {
            enabled = false
        },
        blur = {
            enabled = true,
            size = 5,
            passes = 4,
            new_optimizations = true,
            ignore_opacity = true,
            xray = true
        }
    }

    -- If uncomment, migrate colors as above
    -- col = {
    --     border_active = "rgba(90ceaaff) rgba(ecd3a0ff) 45deg",
    --     border_inactive = "rgba(86aaeccc) rgba(93cee9cc) 45deg",
    --     border_locked_active = "rgba(90ceaaff) rgba(ecd3a0ff) 45deg",
    --     border_locked_inactive = "rgba(86aaeccc) rgba(93cee9cc) 45deg"
    -- }
})
