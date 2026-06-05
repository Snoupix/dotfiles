-- Animations configuration

hl.config({
    animations = {
        enabled = true
    }
})

hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "windows", bezier = "wind", style = "slide", enabled = true, speed = 3 })
hl.animation({ leaf = "windowsIn", bezier = "winIn", style = "slide", enabled = true, speed = 3 })
hl.animation({ leaf = "windowsOut", bezier = "winOut", style = "slide", enabled = true, speed = 3 })
hl.animation({ leaf = "windowsMove", bezier = "wind", style = "slide", enabled = true, speed = 3 })
hl.animation({ leaf = "border", bezier = "liner", enabled = true, speed = 3 })
hl.animation({ leaf = "borderangle", bezier = "liner", style = "loop", enabled = true, speed = 3 })
hl.animation({ leaf = "fade", bezier = "default", enabled = true, speed = 3 })
hl.animation({ leaf = "workspaces", bezier = "wind", enabled = true, speed = 3 })
