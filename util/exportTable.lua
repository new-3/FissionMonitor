function exportTabletoText(dataTable, fileName)
  
  local path_name = "main/tableStructure/" .. fileName .. ".txt"
  local file = io.open(path_name, 'w')
  local text = textutils.serialise(dataTable)
  if file then
    file:write(text)
    file:close()
  else printError("Couldn't write " .. path_name)
  end
end

return {write = exportTabletoText}