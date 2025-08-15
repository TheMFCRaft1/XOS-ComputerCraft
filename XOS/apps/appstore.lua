-- /XOS/apps/appstore.lua

os.loadAPI("/XOS/lib/gui.lua")

local function fetchAppList()
  local res = http.get("http://node03.team.the-network.cloud:27022/xos-apps/apps_list.php")
  if not res then return {} end
  local content = res.readAll()
  res.close()
  local ok, data = pcall(textutils.unserializeJSON, content)
  return ok and data or {}
end

local function installApp(app)
  print("Installiere " .. app.name .. "...")
  local base = "http://node03.team.the-network.cloud:27022/xos-apps/apps/" .. app.id .. "/"

  shell.run("wget " .. base .. app.appFile .. " /XOS/apps/" .. app.id:gsub("/", "_") .. ".lua")
  if app.iconFile then
    shell.run("wget " .. base .. app.iconFile .. " /XOS/icons/" .. app.id:gsub("/", "_") .. ".icon")
  end
  print("✓ Installiert!")
  sleep(1)
end

local function showStore()
  gui.clear(colors.black)
  term.setCursorPos(2, 2)
  print("== XOS App Store ==")

  local apps = fetchAppList()
  local y = 4

for _, app in ipairs(apps) do
    term.setCursorPos(2, y)
    term.setTextColor(colors.yellow)
    print(app.name)

    term.setCursorPos(4, y + 1)
    term.setTextColor(colors.white)
    print((app.description or "Keine Beschreibung"):sub(1, 30))

    -- Install Button rechts
    local btnX = math.max(20, #app.name + 5) -- Dynamische Position
    gui.registerArea(btnX, y, 9, 1, function()
        installApp(app)
    end)

    term.setCursorPos(btnX, y)
    term.setTextColor(colors.green)
    term.write("[Install]")

    y = y + 3
end
  term.setCursorPos(2, y)
  term.setTextColor(colors.white)
  print("Drücke 'q' zum Beenden.")

  -- Event-Handler für Tasteneingaben
  gui.registerKeyHandler(function(key)
    if key == "q" then
      return false -- Beendet die GUI
    end
    return true -- Weiterhin Eingaben akzeptieren
  end)

  gui.render()
end

-- GUI starten
showStore()
while true do
  local e, b, x, y = os.pullEvent("mouse_click")
  gui.handleClick(x, y)
end
