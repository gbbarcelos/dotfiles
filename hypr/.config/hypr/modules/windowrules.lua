hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({ match = { title = "Open Folder" },                   float = true })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" },    float = true })
hl.window_rule({ match = { class = "wiremix" }, float = true, size = "720 340", move = "monitor_w-730 50" })
hl.window_rule({ match = { class = "yazi-float" }, float = true, size = "1200 750", center = true })
hl.window_rule({ match = { class = "steam", title = "Lista de amigos" }, float = true, size = "300 600", center = true })
hl.window_rule({ match = { class = "steam", title = "Friends List" },    float = true, size = "300 600", center = true })

hl.window_rule({ match = { class = "steam_app.*" },      opacity = "1.0 override 1.0 override" })
hl.window_rule({ match = { class = "kitty" },            opacity = "0.92 override 0.82 override" })
hl.window_rule({ match = { class = "yazi-float" },       opacity = "0.92 override 0.82 override" })
hl.window_rule({ match = { class = "wiremix" },          opacity = "0.92 override 0.82 override" })
hl.window_rule({ match = { class = "org.pwmt.zathura" }, opacity = "0.90 override 0.85 override" })
hl.window_rule({ match = { class = "org.kde.dolphin" },  opacity = "0.90 override 0.85 override" })

local layers = {
    { "wofi", 0.1 },
    { "waybar", nil },
    { "swaync-control-center", 0.2 },
    { "swaync-notification-window", 0.2 },
    { "logout_dialog", 0 },
}
for _, l in ipairs(layers) do
    hl.layer_rule({ match = { namespace = l[1] }, blur = true, ignore_alpha = l[2] })
end
