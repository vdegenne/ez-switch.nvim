local M = {}

---@param opts EzSwitchOptions?
function M.setup(opts)
	require("ez-switch.config").setup(opts)
end

function M.focus_sorted_nth_buffer(n)
	n = n or 2
	local buffers = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })

	-- Sort buffers by 'lastused' property (most recently used first)
	table.sort(buffers, function(a, b)
		return a.lastused > b.lastused
	end)

	-- Switch to the nth buffer if it exists
	if #buffers >= n then
		local win = vim.fn.win_findbuf(buffers[n].bufnr)[1]
		if win then
			vim.api.nvim_set_current_win(win)
		else
			vim.cmd("buffer " .. buffers[n].bufnr)
		end
	else
		vim.notify("Less than " .. n .. " buffers in history", vim.log.levels.WARN)
	end
end

local tab_timer

function M.switch()
	tab_timer = tab_timer or (vim.uv or vim.loop).new_timer()
	if tab_timer:is_active() then
		tab_timer:stop()
		M.focus_sorted_nth_buffer(2)
	else
		tab_timer:start(500, 0, function() end)
		return "<Tab>"
	end
end

vim.keymap.set("n", "<Tab>", M.switch, { noremap = true, silent = true, desc = "Switch buffer on double <Tab>" })

return M
