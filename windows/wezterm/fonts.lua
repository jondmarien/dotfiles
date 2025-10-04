-- HeyItsGilbert dotfiles -- chrono edit
local wezterm = require("wezterm")

local fonts = {}

function fonts.setup(config)
	config.font = wezterm.font_with_fallback({
		{
			family = "CaskaydiaMono Nerd Font", weight = "Regular"
		},
		{
			family = "CaskaydiaMono Nerd Font", weight = "Regular"
		},
		{
			family = "CaskaydiaMono Nerd Font", weight = "Regular"
		},
		{
			family = "CaskaydiaMono Nerd Font", weight = "Regular"
		},
	})
	config.font_size = 18
	config.window_frame = {
		font = wezterm.font({ family = "CaskaydiaMono Nerd Font", weight = "Regular" }),
		active_titlebar_bg = "#0c0b0f",
		font_size = 18,
	}
end

return fonts