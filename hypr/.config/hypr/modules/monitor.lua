hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0",       scale = 1 })
hl.monitor({ output = "eDP-1",    mode = "1920x1080", position = "auto-down", scale = 1 })

-- Desliga a tela do notebook ao fechar a tampa
hl.bind("switch:on:Lid Switch", function()
    hl.monitor({ output = "eDP-1", disabled = true })
end, { locked = true })
hl.bind("switch:off:Lid Switch", function()
    hl.monitor({ output = "eDP-1", mode = "1920x1080", position = "auto-down", scale = 1 })
end, { locked = true })
