-- /XOS/main.lua
os.loadAPI("/XOS/lib/gui.lua")
os.loadAPI("/XOS/lib/utils.lua")

local screenW, screenH = term.getSize()

local function getApps()
  local list = fs.list("/XOS/apps")
  local apps = {}
  for _, file in ipairs(list) do
    if file:sub(-4) == ".lua" then
      local id = file:sub(1, -5)
      table.insert(apps, {
        id = id,
        name = id:sub(1, 1):upper() .. id:sub(2), -- Capitalized name
        exec = "/XOS/apps/" .. file
      })
    end
  end
  return apps
end

local function drawTopBar()
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  term.setCursorPos(1, 1)
  term.write(string.rep(" ", screenW))
  local time = textutils.formatTime(os.time(), true)
  term.setCursorPos(screenW - #time - 1, 1)
  term.write(time)
end

local function drawBottomBar()
  term.setBackgroundColor(colors.gray)
  term.setCursorPos(1, screenH)
  term.write("  [Home]        [Back]")
end

local function drawHomeScreen()
  local apps = getApps()
  gui.clear(colors.black)
  drawTopBar()
  drawBottomBar()
  gui.clearAreas()

  local iconSize = 5
  local spacing = 3
  local cols = 3
  local startX = 4
  local startY = 3

  for i, app in ipairs(apps) do
    local col = (i - 1) % cols
    local row = math.floor((i - 1) / cols)

    local x = startX + col * (iconSize + spacing)
    local y = startY + row * (iconSize + spacing + 1)

    local iconPath = "/XOS/icons/" .. app.id .. ".icon"
    local icon = utils.fileExists(iconPath) and dofile(iconPath) or utils.defaultIcon()

    gui.drawAppIcon(x, y, icon, app.name)
    gui.registerArea(x, y, iconSize, iconSize + 1, function()
      shell.run(app.exec)
    end)
  end
end

-- Main loop
while true do
  drawHomeScreen()
  local e, b, x, y = os.pullEvent("mouse_click")
  if y == screenH then
    if x >= 3 and x <= 8 then
      -- Home gedrückt
    elseif x >= 18 and x <= 25 then
      shell.run("/XOS/main.lua") -- Zurück
    end
  else
    gui.handleClick(x, y)
  end
end
