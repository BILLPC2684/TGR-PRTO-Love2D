--###########################--
--###########################--
--#      THE GAME RAZER     #--
--#   ASM TO BIN CONVERTER  #--
--#     **DO NOT EDIT**     #--
--###########################--
--###########################--
--###########################--


opcode_name   = {"-halt","devicenum","-vjmp","-jmp","vjmp","jmp","print","load","add","sub","div","mul","ramp","wram","rram","split","combine","or","and","xor","not","devicesend","devicerecv","if",}
opcode_length = {0      ,1          ,1      ,1     ,1     ,1    ,1      ,2     ,2    ,2    ,2    ,2    ,2     ,2     ,2     ,2      ,2        ,2   ,2    ,2    ,2    ,2           ,2           ,3   ,}

io.write("input filename: ")
filename = io.read()

ifile = io.open(filename,"r")
program = ifile:read("*all")
ifile:close()

--print(program)

io.write("output filename: ")
filename2 = io.read()

function callREG(REG)
 if REG == "a" then
  return 0
 elseif REG == "b" then
  return 1
 elseif REG == "c" then
  return 2
 elseif REG == "d" then
  return 3
 elseif REG == "e" then
  return 4
 elseif REG == "f" then
  return 5
 elseif REG == "g" then
  return 6
 elseif REG == "h" then
  return 7
 elseif REG == "nul" then
  return 0
 else
  error("REG["..REG.."] does not exist in [A,B,C,D,E,F,G,H]")
 end
end

function string.fromhex(str)
 local x = {}
 for y in str:gmatch('(..)') do
  if y ~= "0x" then
   x[#x+1] = string.char(tonumber(y, 16))
   --print(string.char(tonumber(y, 16)))
  end
 end
 return table.concat(x)
end

--VAR TESTING--
jmps = {}
var = {} --Var location in RAM

getmetatable('').__index = function(str,i)
 if type(i) == 'number' then
  return string.sub(str,i,i)
 else
  return string[i]
 end
end

function var(name)
 for i=1,#var do
  if var[i] == name then
   j = i
  end
 end
 if not j then
  table.insert(var,name)
 else
  return j
 end
end
function split(string,str)
 local lines = {}
 local l = ""
 for i=1,#string do
  if string[i] == str then
   table.insert(lines,l)
   l = ""
  else
   l = l..string[i]
  end
 end
 if l then
  table.insert(lines,l)
 end
 return lines
end
program = split(program,"\n")
programout = {}
for i=1,#program do
 line = split(program[i]," ")
 if #line > 1 then
  args = split(line[2],",")
 else
  args = {}
 end
 print(i,program[i])
 if line[1] == "-end" then
  ofile = io.open(filename2,"wb")
  print("-----[[DEBUG-PRINT]]------")
  for i=1,#programout do
   print(programout[i])
   ofile:write(string.char(programout[i]))
  end
  print("----[[END-OF-PROGRAM]]----")
  ofile.close()
 
 --0x01, 2-args[1REGS/1IMM], "LOAD"
 elseif line[1] == "load" then
  table.insert(programout,0x01)
  print("\""..string.fromhex(args[2]).."\" "..#string.fromhex(args[2]))
  if #string.fromhex(args[2]) < 2 then
   table.insert(programout,0x00)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,math.floor(args[2]))
  else
   table.insert(programout,0x01)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,math.floor(string.byte(string.fromhex(args[2])[1])))
   table.insert(programout,math.floor(string.byte(string.fromhex(args[2])[2])))
  end
 
 --0x02, 2-args[2REGS], "ADD"
 elseif line[1] == "add" then
  if tonumber(args[2]) == nil then
   table.insert(programout,0x02)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,callREG(args[2]))
  else--0x06, 2-args[1REGS/1IMM], "ADDI"
   table.insert(programout,0x06)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,math.floor(args[2]))
  end
 --0x03, 2-args[2REGS], "SUB"
 elseif line[1] == "sub" then
  if tonumber(args[2]) == nil then
   table.insert(programout,0x03)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,callREG(args[2]))
  else--0x07, 2-args[1REGS/1IMM], "SUBI"
   table.insert(programout,0x07)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,math.floor(args[2]))
  end
 --0x04, 2-args[2REGS], "DIV"
 elseif line[1] == "div" then
  if tonumber(args[2]) == nil then
   table.insert(programout,0x04)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,callREG(args[2]))
  else--0x08, 2-args[1REGS/1IMM], "DIVI"
   table.insert(programout,0x08)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,math.floor(args[2]))
  end
 --0x05, 2-args[2REGS], "MUL"
 elseif line[1] == "mul" then
  if tonumber(args[2]) == nil then
   table.insert(programout,0x05)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,callREG(args[2]))
  else--0x09, 2-args[1REGS/1IMM], "MULI"
   table.insert(programout,0x09)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,math.floor(args[2]))
  end
 
 --0x0a, 1-args[1REGS], "JMP/I"
 elseif line[1] == "jmp" then
  if tonumber(args[2]) == nil then
   table.insert(programout,0x0a)
   table.insert(programout,callREG(args[1]))
  else--0x0b, 1-args[1IMM], "JMPI"
   table.insert(programout,0x0b)
   table.insert(programout,math.floor(args[1]))
  end
 elseif line[1] == "-vjmp" then
  print(">"..#programout)
  jmps[args[1]] = #programout
 elseif line[1] == "vjmp" then
  print(">"..math.floor(jmps[args[1]]))
  table.insert(programout,0x0b)
  table.insert(programout,math.floor(jmps[args[1]]))
 
 --0x0c, 1-args[1REGS], "PNT"
 elseif line[1] == "print" then
  table.insert(programout,0x0c)
  table.insert(programout,callREG(args[1]))
 
 --0x0d, 0-args[], "HALT"
 elseif line[1] == "-halt" then
 table.insert(programout,0x0d)
 
 --0x0e, 2-args[2REGS], "RAMPOS"
 elseif line[1] == "rampos" then
  if tonumber(args[2]) == nil then
   table.insert(programout,0x0e)
   table.insert(programout,args[1])
   table.insert(programout,callREG(args[2]))
  else--0x0F, 3-args[3REGS], "RAMPOSI"
   table.insert(programout,0x0f)
   table.insert(programout,args[1])
   table.insert(programout,callREG(args[2]))
   table.insert(programout,callREG(args[3]))
  end
 --0x10, 2-args[2REGS], "WRAM"
 elseif line[1] == "wram" then
  table.insert(programout,0x10)
  table.insert(programout,callREG(args[1]))
  table.insert(programout,math.floor(args[2]))
 --0x11, 2-args[2REGS], "RRAM"
 elseif line[1] == "rram" then
  table.insert(programout,0x11)
  table.insert(programout,callREG(args[1]))
  table.insert(programout,math.floor(args[2]))
 
 --0x12, 2-args[2REGS], "SPLIT"
 elseif line[1] == "split" then
  table.insert(programout,0x12)
  table.insert(programout,callREG(args[1]))
  table.insert(programout,callREG(args[2]))
 --0x13, 2-args[2REGS], "COMB"
 elseif line[1] == "comb" then
  table.insert(programout,0x13)
  table.insert(programout,callREG(args[1]))
  table.insert(programout,callREG(args[2]))

 --0x14, 2-args[2REGS], "OR"
 elseif line[1] == "RAMPOS" then
  if tonumber(args[1]) == nil then
   table.insert(programout,0x14)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,callREG(args[2]))
  else--0x18, 2-args[2REGS], "ORI"
   table.insert(programout,0x18)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,math.floor(args[2]))
  end
 --0x15, 2-args[2REGS], "AND"
 elseif line[1] == "RAMPOS" then
  if tonumber(args[1]) == nil then
   table.insert(programout,0x15)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,callREG(args[2]))
  else--0x19, 2-args[1REGS/1IMM], "ANDI"
   table.insert(programout,0x19)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,math.floor(args[2]))
  end
 --0x16, 2-args[2REGS], "XOR"
 elseif line[1] == "RAMPOS" then
  if tonumber(args[1]) == nil then
   table.insert(programout,0x16)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,callREG(args[2]))
  else--0x1a, 2-args[1REGS/1IMM], "XORI"
   table.insert(programout,0x1a)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,math.floor(args[2]))
  end
 --0x17, 2-args[2REGS], "NOT"
 elseif line[1] == "RAMPOS" then
  if tonumber(args[1]) == nil then
   table.insert(programout,0x17)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,callREG(args[2]))
  else--0x1b, 2-args[1REGS/1IMM], "NOTI"
   table.insert(programout,0x1b)
   table.insert(programout,callREG(args[1]))
   table.insert(programout,math.floor(args[2]))
  end
 --0x1c, 1-args[1REGS], "DVCNUM"
 elseif line[1] == "devicenum" then
  table.insert(programout,0x1c)
  table.insert(programout,math.floor(args[1]))
 --0x1d, 2-args[2REGS], "SNDDVC"
 elseif line[1] == "devicesend" then
  table.insert(programout,0x1d)
  table.insert(programout,math.floor(args[1]))
  table.insert(programout,callREG(args[2]))
 --0x1e, 2-args[2REGS], "RVCDVC"
 elseif line[1] == "devicerec" then
  table.insert(programout,0x1e)
  table.insert(programout,math.floor(args[1]))
  table.insert(programout,callREG(args[2]))
 
 --0x1f, 3-args[2REGS|/2IMM], "IF(CMP)
 elseif line[1] == "if" then
  table.insert(programout,0x1f)
  if line[3] == "==" then
   table.insert(programout,0)
  elseif line[3] == "<" then
   table.insert(programout,1)
  elseif line[3] == ">" then
   table.insert(programout,2)
  elseif line[3] == "!=" then
   table.insert(programout,3)
  end
  table.insert(programout,callREG(line[2]))
  table.insert(programout,callREG(line[4]))
  print(split(program[i+1]," ")[1])
  for l=1,#opcode_name do
   --print("> "..opcode_name[l].."       \t"..split(program[i+1]," ")[1])
   if opcode_name[l] == split(program[i+1]," ")[1] then
    --print(">> got "..opcode_name[l])
    table.insert(programout,opcode_length[l]+1)
	print(#programout+(opcode_length[l]+1))
    break
   end
  end

 --0x20, 0-args[], "NIL"
 elseif line[1] == "" then
  
 end
end