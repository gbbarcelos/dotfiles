hl.config({
    input = {
        kb_layout    = "brcustom",
        kb_variant   = "",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            disable_while_typing = true,
            scroll_factor        = 0.8,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "up",         action = "special" })
hl.gesture({ fingers = 4, direction = "down",       action = "close" })
