local M = {}

M.setup = function()
  vim.keymap.set("n", "<leader>r", M.reload)
  vim.keymap.set("n", "<leader>F", M.run_file)
end

M.build_run_spec_command = function(type, filename)
  local command = {}
  local gemfile_path = vim.fn.getcwd() .. "/Gemfile"
  local file = io.open(gemfile_path, "r")
  if file then
    table.insert(command, "bundle")
    table.insert(command, "exec")
  end

  table.insert(command, "rspec")
  table.insert(command, filename)
  return command
end

M.reload = function()
  require("lazy.core.loader").reload("nspect")
end

M.run_file = function()
  local filename = vim.api.nvim_buf_get_name(0)
  if not filename:match("spec%.rb$") then
    print("Not in an rspec file")
    return
  end

  local command = M.build_run_spec_command("file", filename)
  local outbuf = vim.api.nvim_create_buf(false, false)
  local outdata = table.concat(command, " ").."\n"

  vim.api.nvim_open_win(outbuf, true, {
    split = "right",
    win = 0,
  })
  vim.system(command, {text = false, stdout = function(err, data)
    if data == nil then
      return
    end

    outdata = outdata .. data

    vim.schedule(function()
      local lines = vim.split(outdata, "\n")
      vim.api.nvim_buf_set_lines(outbuf, 0, -1, false, lines)
    end)
  end})
end

return M
