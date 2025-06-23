-- /XOS/apps/appstore.lua
os.loadAPI("/XOS/lib/gui.lua")
os.loadAPI("/XOS/lib/utils.lua")

local function fetchAppList()
  local tempPath = "/.applist.tmp"
  if fs.exists(tempPath) then fs.delete(tempPath) end
  shell.run("wget https://raw.githubusercontent.com/TheMFCRaft1/XOS-ComputerCraft/main/appstore.lua " .. tempPath)
  local list = dofile(tempPath)
  fs.delete(tempPath)
  return list
end

local function installApp(app)
  print("Installiere '" .. app.name .. "'...")
  shell.run("wget " .. app.appUrl .. " /XOS/apps/" .. app.id .. ".lua")
  if app.iconUrl then
    shell.run("wget " .. app.iconUrl .. " /XOS/icons/" .. app.id .. ".icon")
  end
  print("✓ Installiert!")
  sleep(1)
end

local function showStore()
  local apps = fetchAppList()
  gui.clear(colors.black)
  term.setCursorPos(2, 2)
  print("== XOS App Store ==")

  local y = 4
  for _, app in ipairs(apps) do
    term.setCursorPos(2, y)
    term.setTextColor(colors.yellow)
    print(app.name)
    term.setCursorPos(4, y + 1)
    term.setTextColor(colors.white)
    print(app.description:sub(1, 30))
    gui.registerArea(30, y, 8, 1, function()
      installApp(app)
    end)
    term.setCursorPos(30, y)
    term.setTextColor(colors.lime)
    term.write("[Install]")
    y = y + 3
  end
end

-- Start der App
showStore()
while true do
  local e, b, x, y = os.pullEvent("mouse_click")
  gui.handleClick(x, y)
end
