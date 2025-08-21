return {
  'saghen/blink.nvim', -- コンマを追加
  build = 'cargo build --release', -- for delimiters
  keys = {
    -- chartoggle
    {
      ';',
      function()
        require('blink.chartoggle').toggle_char_eol(';')
      end,
      mode = { 'n', 'v' },
      desc = 'Toggle ; at eol',
    },
    {
      ',',
      function()
        require('blink.chartoggle').toggle_char_eol(',')
      end,
      mode = { 'n', 'v' },
      desc = 'Toggle , at eol',
    },
  },
  -- all modules handle lazy loading internally
  lazy = false,
  opts = {
    chartoggle = { enabled = true }
  },
}
