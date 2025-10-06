vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.wrap = false

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true })
vim.keymap.set('n', '<leader>b', function()
    -- OSによってコマンドを切り替え
    local cmd
    if vim.fn.has("mac") == 1 then
        cmd = 'open'
    elseif vim.fn.has("win32") == 1 then
        cmd = 'explorer'
    else
        cmd = 'xdg-open'
    end
    -- コマンドを実行
    vim.cmd('!'.cmd .. ' ' .. vim.fn.expand('%:p') .. ' &')
end, { noremap = true, silent = true, desc = 'Open current file in browser' })
