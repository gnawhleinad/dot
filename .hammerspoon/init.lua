local hotkey = require "hs.hotkey"
local grid = require "hs.grid"
local window = require "hs.window"
local screen = require "hs.screen"

grid.GRIDWIDTH = 8
grid.GRIDHEIGHT = 2

window.animationDuration = 0

local function push_window(d)
  local win = window.focusedWindow()
  if win ~= nil then
    local x = 0
    local y = 0
    local w = grid.GRIDWIDTH/2
    local h = grid.GRIDHEIGHT
    local cell = grid.get(win)

    if d == 'left' then
      if cell.x == grid.GRIDWIDTH/2 then
        w = grid.GRIDWIDTH/2
      elseif cell.x == grid.GRIDWIDTH*(5/8) then
        w = grid.GRIDWIDTH*(3/8)
      elseif cell.x == grid.GRIDWIDTH*(3/8) then
        w = grid.GRIDWIDTH*(5/8)
      elseif cell.w == grid.GRIDWIDTH/2 then
        w = grid.GRIDWIDTH*(3/8)
      elseif cell.w == grid.GRIDWIDTH*(3/8) then
        w = grid.GRIDWIDTH*(5/8)
      else
        w = grid.GRIDWIDTH/2
      end
      x = 0
    elseif d == 'down' then
      y = grid.GRIDHEIGHT/2
      w = grid.GRIDWIDTH
      h = grid.GRIDHEIGHT/2
    elseif d == 'up' then
      y = 0
      w = grid.GRIDWIDTH
      h = grid.GRIDHEIGHT/2
    elseif d == 'right' then
      if cell.x == 0 then
        w = cell.w
        if w == grid.GRIDWIDTH/2 then
          x = grid.GRIDWIDTH/2
        elseif w == grid.GRIDWIDTH*(3/8) then
          x = grid.GRIDWIDTH-3
        else
          x = grid.GRIDWIDTH-5
        end
      elseif cell.w == grid.GRIDWIDTH/2 then
        x = grid.GRIDWIDTH-3
        w = grid.GRIDWIDTH*(3/8)
      elseif cell.w == grid.GRIDWIDTH*(3/8) then
        x = grid.GRIDWIDTH-5
        w = grid.GRIDWIDTH*(5/8)
      else
        x = grid.GRIDWIDTH/2
        w = grid.GRIDWIDTH/2
      end
    end

    grid.adjustWindow(function(f)
      f.x = x
      f.y = y
      f.w = w
      f.h = h
    end, win)
  end
end

local function move_window(d)
  local win = window.focusedWindow()
  if win ~= nil then
    local y = 0
    local w = grid.GRIDWIDTH/2
    local h = grid.GRIDHEIGHT/2

    if d == 'down' then
      y = grid.GRIDHEIGHT/2
    elseif d == 'up' then
      y = 0
    end

    grid.adjustWindow(function(f)
      f.y = y
      f.w = w
      f.h = h
    end, win)
  end
end

local function size_window(d)
  local win = window.focusedWindow()
  if win ~= nil then
    if d == 'min' then win:minimize()
    elseif d == 'max' then grid.maximizeWindow()
    end
  end
end

local function next_screen()
  local win = window.focusedWindow()
  win:moveToScreen(win:screen():next())
end

mash = {"cmd", "ctrl"}

hotkey.bind(mash, 'H', function() push_window('left') end)
hotkey.bind(mash, 'J', function() push_window('down') end)
hotkey.bind(mash, 'K', function() push_window('up') end)
hotkey.bind(mash, 'L', function() push_window('right') end)

hotkey.bind(mash, 'N', function() next_screen() end)
hotkey.bind(mash, 'P', function() next_screen() end)

mash = {"cmd", "ctrl", "shift"}

hotkey.bind(mash, 'J', function() size_window('min') end)
hotkey.bind(mash, 'K', function() size_window('max') end)

mash = {"ctrl", "shift"}
hotkey.bind(mash, 'J', function() move_window('down') end)
hotkey.bind(mash, 'K', function() move_window('up') end)
