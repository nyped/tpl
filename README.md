# tpl

a template creator (the kiss way)

# dependencies

- `bash`
- `envsubst` (from `gettext`)

# installation / uninstallation

```bash
# make install
# make uninstall
```

# usage

## from a shell

```bash
$ tpl -h        # shows a help message
$ tpl -l        # lists available templates
$ tpl foo/bar.c # creates a "c" template
$ tpl c         # prints a "c" template to stdout
```

## from `Neovim`

You can define a user command named `Tpl`, this way:

```lua
vim.api.nvim_create_user_command("Tpl", function(opts)
  local empty_buf = vim.fn.line("$") == 1
    and vim.api.nvim_get_current_line():len() == 0
  local prefix = ""

  if opts.range ~= 0 then
    prefix = [['<.'>]]
  elseif opts.bang or empty_buf then
    prefix = "%"
  end

  vim.cmd(prefix .. "!tpl " .. tostring(opts.args))
end, {
  bang = true,
  desc = "Tpl: template creator",
  nargs = 1,
  range = true,
  complete = function(cmd)
    local ret = {}
    local tmp_ft =
      vim.split(vim.fn.system({ "tpl", "--list" }), "\n", { trimempty = true })

    for _, value in ipairs(tmp_ft) do
      if string.find(value, cmd) then
        table.insert(ret, value)
      end
    end

    return ret
  end,
})
```

You will be able to call `:Tpl ext` on an empty buffer, `:Tpl! ext` on a
used buffer, or `:'<.'>Tpl ext` in visual mode.
