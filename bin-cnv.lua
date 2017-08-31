---###########################--		
---###########################--		
---#      THE GAME RAZER     #--		
---#      BIN CONVERTER      #--		
---#     **DO NOT EDIT**     #--		
---###########################--		
---###########################--		
---###########################--
io.write("input filename: ")
require(io.read())

io.write("output filename: ")
filename = io.read()

file = io.open(filename,"wb")
print("-----[[DEBUG-PRINT]]------")
for i=1,#ROM do
 print(ROM[i])
 file:write(string.char(ROM[i]))
end
print("----[[END-OF-PROGRAM]]----")
file.close()
