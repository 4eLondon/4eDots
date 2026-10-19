return {
  entry = function()
    local options = {
      { name = "Code", path = "~/code" },
      { name = "Downloads", path = "~/Downloads" },
      { name = "Documents", path = "~/Documents" },
      { name = "Projects", path = "~/projects" },
      { name = "Config", path = "~/.config" },
    }

    local items = {}
    for i, opt in ipairs(options) do
      items[i] = ui.ListItem(opt.name)
    end

    local choice = ya.input({
      title = "Go to:",
      items = items,
    })

    if choice and choice > 0 then
      ya.manager_emit("cd", { options[choice].path })
    end
  end,
}
