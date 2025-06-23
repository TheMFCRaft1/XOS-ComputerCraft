-- /XOS/lib/utils.lua

-- Zentriert Text auf gegebener Y-Position
function centerText(y, text, color)
  local w = term.getSize()
  term.setCursorPos(math.floor((w - #text) / 2), y)
  if color then term.setTextColor(color) end
  term.write(text)
end

-- Prüft ob Datei existiert
function fileExists(path)
  local f = fs.open(path, "r")
  if f then f.close() return true end
  return false
end

-- Einfache Logfunktion
function log(msg)
  local f = fs.open("/XOS/log.txt", "a")
  if f then
    f.writeLine("[" .. textutils.formatTime(os.time(), true) .. "] " .. msg)
    f.close()
  end
end

-- Formatiert die Uhrzeit als HH:MM
function formatTimePretty()
  return textutils.formatTime(os.time(), true)
end

-- /XOS/lib/utils.lua

function fileExists(path)
  local f = fs.open(path, "r")
  if f then f.close() return true end
  return false
end

function defaultIcon()
  local c = colors.gray
  return {
    {c, c, c, c, c},
    {c, colors.black, colors.black, colors.black, c},
    {c, colors.black, c, colors.black, c},
    {c, colors.black, colors.black, colors.black, c},
    {c, c, c, c, c}
  }
end
