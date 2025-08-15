-- /XOS/main.lua

os.loadAPI("/XOS/lib/gui.lua")

local screenW, screenH = term.getSize()
local appAreaY = 2
local appAreaH = screenH - 2

-- Verbesserte App-Ladefunktion
local function getApps()
  if not fs.exists("/XOS/apps") then return {} end
  local list = fs.list("/XOS/apps")
  local apps = {}
  for _, file in ipairs(list) do
    local path = fs.combine("/XOS/apps", file)
    if fs.isDir(path) then
      if fs.exists(fs.combine(path, "main.lua")) then
        table.insert(apps, {
          id = file,
          name = file:sub(1, 1):upper() .. file:sub(2),
          exec = fs.combine(path, "main.lua")
        })
      end
    elseif file:sub(-4) == ".lua" then
      local id = file:sub(1, -5)
      table.insert(apps, {
        id = id,
        name = id:sub(1, 1):upper() .. id:sub(2),
        exec = fs.combine("/XOS/apps", file)
      })
    end
  end
  return apps
end

local function drawTopBar(notify)
  term.setBackgroundColor(colors.gray)
  term.setTextColor(colors.white)
  term.setCursorPos(1, 1)
  term.write((notify and "🔔" or " ") .. " ")
  local time = textutils.formatTime(os.time(), true)
  term.setCursorPos(screenW - #time - 1, 1)
  term.write(time)
end

local function drawBottomBar()
  term.setBackgroundColor(colors.gray)
  term.setCursorPos(1, screenH)
  term.setTextColor(colors.black)
  term.write(" □   < ")
end

local function drawHomeScreen()
  gui.clear(colors.black)
  drawTopBar()
  drawBottomBar()
  gui.clearAreas()

  local apps = getApps()
  local iconSize = 5
  local spacing = 2
  local cols = 5
  local startX = 3
  local startY = 3

  for i, app in ipairs(apps) do
    local col = (i - 1) % cols
    local row = math.floor((i - 1) / cols)

    local x = startX + col * (iconSize + spacing)
    local y = startY + row * (iconSize + spacing + 1)

    local iconPath = "/XOS/icons/" .. app.id .. ".icon"
    local icon = fs.exists(iconPath) and dofile(iconPath) or {
      {colors.gray, colors.gray, colors.gray, colors.gray, colors.gray},
      {colors.gray, colors.black, colors.black, colors.black, colors.gray},
      {colors.gray, colors.black, colors.gray, colors.black, colors.gray},
      {colors.gray, colors.black, colors.black, colors.black, colors.gray},
      {colors.gray, colors.gray, colors.gray, colors.gray, colors.gray},
    }

    gui.drawAppIcon(x, y, icon, app.name)
    gui.registerArea(x, y, iconSize, iconSize + 1, function()
      launchApp(app)
    end)
  end
end

-- Einfacher direkter App-Start
function launchApp(app)
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1, 1)

  shell.run(app.exec)

  -- Nach App-Ende wieder Home anzeigen
  drawHomeScreen()
end

-- Main-Loop
drawHomeScreen()
while true do
  drawTopBar()
  local e, b, x, y = os.pullEvent()
  if e == "mouse_click" then
    if y == screenH then
      if x == 2 then
        drawHomeScreen() -- Home
      elseif x == 6 then
        drawHomeScreen() -- Zurück
      end
    else
      gui.handleClick(x, y)
    end
  elseif e == "timer" then
    drawTopBar()
  end
end
