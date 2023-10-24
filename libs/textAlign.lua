-- left/center/right print in a selected row and ranged columns
-- erase selected area in a row

func = {}

local expect = require "cc.expect".expect

function func.centeredPrint(x0, x1, y, text, tColor, bColor)
  expect(1, x0, "number")
  expect(2, x1, "number")
  expect(3, y, "number")
  expect(4, text, "string")
  expect(5, tColor, "number", "nil")
  expect(6, bColor, "number", "nil")

  if tColor ~= nil then term.setTextColor(tColor) end
  if bColor ~= nil then term.setBackgroundColor(bColor) end

  if text:len() > x1-x0+1 then
    text = text:sub(1, x1-x0+1)    
  end

  term.setCursorPos(math.floor(x0 + (x1-x0 - #text) / 2) + 1, y)
  term.write(text)
end

function func.rightPrint(x0, x1, y, text, tColor, bColor)
  expect(1, x0, "number")
  expect(2, x1, "number")
  expect(3, y, "number")
  expect(4, text, "string")
  expect(5, tColor, "number", "nil")
  expect(6, bColor, "number", "nil")

  if tColor ~= nil then term.setTextColor(tColor) end
  if bColor ~= nil then term.setBackgroundColor(bColor) end

  for x = x0, x1 do
    term.setCursorPos(x, y)
    term.write(" ")
  end

  if text:len() > x1-x0+1 then
    text = text:sub(1, x1-x0+1)
  end

  term.setCursorPos(x1 - #text + 1, y)
  term.write(text)
end

function func.leftPrint(x0, x1, y, text, tColor, bColor)
  expect(1, x0, "number")
  expect(2, x1, "number")
  expect(3, y, "number")
  expect(4, text, "string")
  expect(5, tColor, "number", "nil")
  expect(6, bColor, "number", "nil")

  if tColor ~= nil then term.setTextColor(tColor) end
  if bColor ~= nil then term.setBackgroundColor(bColor) end

  if text:len() > x1-x0+1 then
    text = text:sub(1, x1-x0+1)
  end

  for x = x0, x1 do
    term.setCursorPos(x, y)
    term.write(" ")
  end
  
  term.setCursorPos(x0, y)
  term.write(text)
end

function func.erase(x0, x1, y, bColor)
  expect(1, x0, "number")
  expect(2, x1, "number")
  expect(3, y, "number")
  expect(4, bColor, "number", "nil")

  if bColor ~= nil then term.setBackgroundColor(bColor) 
  else term.setBackgroundColor(bColor) 
  end

  if x1 > x0 then
    for x = x0, x1 do
      term.setCursorPos(x, y)
      term.write(" ")
    end
  end

end
return func