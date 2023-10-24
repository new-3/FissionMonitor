function reset_color()
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
end

return {reset = reset_color}