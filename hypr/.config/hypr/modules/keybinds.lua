local v   = require("modules.vars")
local mod = v.mainMod
local exec = hl.dsp.exec_cmd

hl.bind(mod .. " + Q",         exec(v.terminal))
hl.bind(mod .. " + E",         exec("~/dotfiles/scripts/.config/scripts/yazi_flutuante.sh"))
hl.bind(mod .. " + W",         exec(v.menu))
hl.bind(mod .. " + S",         exec(v.swaync))
hl.bind(mod .. " + B",         exec("hyprlock"))
hl.bind(mod .. " + A",         hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + A", hl.dsp.window.kill())
hl.bind(mod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F",         hl.dsp.window.bring_to_top())
hl.bind(mod .. " + C",         exec("wlogout -b 4 -T 400 -B 400 -L 480 -R 480"))
hl.bind(mod .. " + N",         exec("kitty nvim"))
hl.bind(mod .. " + SHIFT + R", exec("pkill waybar; setsid waybar"))

-- Prints e gravação de tela
hl.bind("Print",                 exec(v.print .. " full"))
hl.bind("SHIFT + Print",         exec(v.print .. " region"))
hl.bind("SUPER + Print",         exec(v.print .. " rec-full"))
hl.bind("SUPER + SHIFT + Print", exec(v.print .. " rec-region"))
hl.bind("SUPER + X",             exec(v.print .. " stop-rec"))

-- Foco, troca e redimensionamento de janelas
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(mod .. " + " .. dir,          hl.dsp.focus({ direction = dir }))
    hl.bind(mod .. " + CTRL + " .. dir,   hl.dsp.window.swap({ direction = dir }))
end
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.resize({ x =  10, y =   0, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -10, y =   0, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.resize({ x =   0, y = -10, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.resize({ x =   0, y =  10, relative = true }), { repeating = true })

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mídia, volume e brilho
hl.bind("XF86AudioNext",  exec("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  exec("playerctl previous"),   { locked = true })
hl.bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   exec("brightnessctl set 10%+ && pkill -SIGRTMIN+9 waybar"), { locked = true })
hl.bind("XF86MonBrightnessDown", exec("brightnessctl set 10%- && pkill -SIGRTMIN+9 waybar"), { locked = true })
