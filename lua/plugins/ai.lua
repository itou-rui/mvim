return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		opts = function(_, opts)
			opts.window = {
				layout = "float",
				relative = "cursor",
				width = 1,
				height = 0.4,
				row = 1,
			}
		end,
	},
}
