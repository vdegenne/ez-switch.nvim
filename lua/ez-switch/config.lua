local M = {}

---@class EzSwitchOptions
M.defaults = {}

function M.setup()
	vim.keymap.set("n", "<Tab>", function()
		require("ez-switch").switch()
	end, { noremap = true, silent = true, desc = "Switch buffer on double <Tab>" })
end

return M
