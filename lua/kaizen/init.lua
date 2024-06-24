require("kaizen.set")
require("kaizen.remap")

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

if vim.env.ZELLIJ ~= nil then
	vim.fn.system({ "zellij", "action", "switch-mode", "locked" })
end
