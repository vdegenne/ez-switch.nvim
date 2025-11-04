local M = {}

--@param EzSwitchConfig opts
function M.config(opts)
	require("ez-switch.config").config(opts)
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

function M.switch_on_double_tab()
	tab_timer = tab_timer or (vim.uv or vim.loop).new_timer()
	if tab_timer:is_active() then
		tab_timer:stop()
		-- vim.cmd("stopinsert")
		print("NOICE")
	else
		tab_timer:start(200, 0, function() end)
		return "<Tab>"
	end
	-- local now = vim.loop.hrtime() / 1e6
	-- if now - last_tab_time < tab_timeout then
	-- 	M.focus_sorted_nth_buffer(2)
	-- 	-- vim.cmd("b#") -- switch to last used buffer
	-- 	last_tab_time = 0
	-- else
	-- 	last_tab_time = now
	-- end
end

return M
