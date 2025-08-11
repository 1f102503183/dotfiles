vim.api.nvim_create_autocmd("InsertChatPre",{

	print("hello")

	pattern = {"("}

	callback function(args)

		local char = args.data.char

		if char == "(" then
			local col = vim.api.nvim_get_mode().col
			local line =  vim.api.nvim_get_current_line()
			-- カーソルの後ろに　） を挿入
			vim.api.nvim_set_text( 0, 0, col, 0, col, {")"})
		end
	end
})j
