-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "nord",
  transparency = true,


	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },
	},
}

vim.opt.relativenumber = true

return M
