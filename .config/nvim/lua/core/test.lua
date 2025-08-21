-- MyJavaDevという名前の自動コマンドグループを作成
local augroup = vim.api.nvim_create_augroup("MyJavaDev", { clear = true })

-- BufWritePost イベントを検知
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  pattern = "*", -- 全てのファイルを検知する
  callback = function(opts)
    local file_path = vim.api.nvim_buf_get_name(opts.buf)
    
    -- ファイルの拡張子を取得
    local file_ext = vim.fn.fnamemodify(file_path, ":e")

    -- ファイルの拡張子によって処理を分ける
    if file_ext == "java" then
      local class_name = vim.fn.fnamemodify(file_path, ":t:r")
      
      -- javacコマンドでコンパイル
      local compile_cmd = "javac " .. vim.fn.shellescape(file_path)
      vim.cmd("!" .. compile_cmd)
      
      -- コンパイルが成功したらjavaコマンドで実行
      if vim.v.shell_error == 0 then
        local dir_path = vim.fn.fnamemodify(file_path, ":h")
        local run_cmd = "java -cp " .. vim.fn.shellescape(dir_path) .. " " .. class_name
        vim.cmd("!" .. run_cmd)
        
        -- .classファイルを削除
        local class_file = vim.fn.fnamemodify(file_path, ":r") .. ".class"
        vim.cmd("!rm " .. vim.fn.shellescape(class_file))
      end
    elseif file_ext == "py" then
      -- Pythonファイルを実行
      if vim.v.shell_error == 0 then
          local run_cmd = "python3 " .. vim.fn.shellescape(file_path)
          vim.cmd("!" .. run_cmd)
      end
    end
  end
})
