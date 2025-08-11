vim.opt.number = true 
vim.opt.relativenumber = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>",{silent = true})
--vim.keymap.set( 
-- mode "n" normalmode "i" insertmode "v" visualmode "t" turminalmode ,
-- key <C-n> = ctrl+n <leader> = \ or , <CR> = Enter <Tap> = tapkey,
-- execute command,
-- option silent = true => not show turminalmassage
