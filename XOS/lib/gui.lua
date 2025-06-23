-- /XOS/lib/gui.lua

local buttons = {}
local clickAreas = {}

function clear(bg)
  term.setBackgroundColor(bg or colors.black)
  term.clear()
  buttons = {}
  clickAreas = {}
end

function drawButton(x, y, w, h, label, callback)
  table.insert(buttons, {x = x, y = y, w = w, h = h, cb = callback})
  term.setBackgroundColor(colors.lightGray)
  for i = 0, h - 1 do
    term.setCursorPos(x, y + i)
    term.write(string.rep(" ", w))
  end
  term.setTextColor(colors.black)
  term.setCursorPos(x + math.floor((w - #label) / 2), y + math.floor(h / 2))
  term.write(label)
end

function drawAppIcon(x, y, icon, label)
  for row = 1, 5 do
    for col = 1, 5 do
      local color = icon[row] and icon[row][col] or colors.black
      term.setBackgroundColor(color)
      term.setCursorPos(x + col - 1, y + row - 1)
      term.write(" ")
    end
  end
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
  term.setCursorPos(x, y + 5)
  term.write(label:sub(1, 5))
end

function registerArea(x, y, w, h, callback)
  table.insert(clickAreas, {x = x, y = y, w = w, h = h, cb = callback})
end

function handleClick(px, py)
  for _, btn in ipairs(buttons) do
    if px >= btn.x and px < btn.x + btn.w and py >= btn.y and py < btn.y + btn.h then
      btn.cb()
      return
    end
  end
  for _, area in ipairs(clickAreas) do
    if px >= area.x and px < area.x + area.w and py >= area.y and py < area.y + area.h then
      area.cb()
      return
    end
  end
end

function clearAreas()
  clickAreas = {}
end
