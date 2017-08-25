--###########################--
--###########################--
--#      THE GAME RAZER     #--
--# CENTRAL PROCESSING UNIT #--
--#     **DO NOT EDIT**     #--
--###########################--
--###########################--
--###########################--

require("bit")
CPU.commands = 0

function callREG(REG)
 if REG == 0 then
  return "A"
 elseif REG == 1 then
  return "B"
 elseif REG == 2 then
  return "C"
 elseif REG == 3 then
  return "D"
 elseif REG == 4 then
  return "E"
 elseif REG == 5 then
  return "F"
 elseif REG == 6 then
  return "G"
 elseif REG == 7 then
  return "H"
 end
end

function exec()
 --print(tohex(CPU.PC-1),tohex(ROM[CPU.PC]))
 if debug == true then
  EMU.logs = EMU.logs..tohex(CPU.PC-1)..":\tExecuting "..tohex(ROM[CPU.PC])..":\t"
 end
 if ROM[CPU.PC] == 0x00 then
  if debug == true then
   EMU.logs = EMU.logs.."NOP"
  end
 elseif ROM[CPU.PC] == 0x01 then
  CPU.PC = CPU.PC + 3
  if ROM[CPU.PC-2] == 0 then
   if debug == true then
    EMU.logs = EMU.logs.."LOAD "..ROM[CPU.PC-2]..","..callREG(ROM[CPU.PC-1])..","..ROM[CPU.PC].."\t"
   end
   CPU.REGS[callREG(ROM[CPU.PC-1])] = ROM[CPU.PC]%0x10000
  elseif ROM[CPU.PC-2] == 1 then
   CPU.PC = CPU.PC + 1
   if debug == true then
    EMU.logs = EMU.logs.."LOAD "..ROM[CPU.PC-3]..","..callREG(ROM[CPU.PC-2])..","..ROM[CPU.PC-1]..","..ROM[CPU.PC].."\t"
   end
   print(ROM[CPU.PC-1],ROM[CPU.PC],tonumber(tohex(ROM[CPU.PC-1])..tohex(ROM[CPU.PC]),16))
   CPU.REGS[callREG(ROM[CPU.PC-2])] = tonumber(tohex(ROM[CPU.PC-1])..tohex(ROM[CPU.PC]),16)
  end
 elseif ROM[CPU.PC] == 0x02 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."ADD "..callREG(ROM[CPU.PC-1])..","..callREG(ROM[CPU.PC]).."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = (CPU.REGS[callREG(ROM[CPU.PC-1])] + CPU.REGS[callREG(ROM[CPU.PC])])%0x10000
 elseif ROM[CPU.PC] == 0x03 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."SUB "..callREG(ROM[CPU.PC-1])..","..callREG(ROM[CPU.PC]).."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = (CPU.REGS[callREG(ROM[CPU.PC-1])] - CPU.REGS[callREG(ROM[CPU.PC])])%0x10000
 elseif ROM[CPU.PC] == 0x04 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."DIV "..callREG(ROM[CPU.PC-1])..","..callREG(ROM[CPU.PC]).."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = (CPU.REGS[callREG(ROM[CPU.PC-1])] / CPU.REGS[callREG(ROM[CPU.PC])])%0x10000
 elseif ROM[CPU.PC] == 0x05 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."MUL "..callREG(ROM[CPU.PC-1])..","..callREG(ROM[CPU.PC]).."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = (CPU.REGS[callREG(ROM[CPU.PC-1])] * CPU.REGS[callREG(ROM[CPU.PC])])%0x10000
 
 elseif ROM[CPU.PC] == 0x06 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."ADDI "..callREG(ROM[CPU.PC]-1)..","..ROM[CPU.PC].."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = (CPU.REGS[callREG(ROM[CPU.PC-1])] + ROM[CPU.PC])%0x10000
 elseif ROM[CPU.PC] == 0x07 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."SUBI "..callREG(CPU.PC-1)..","..ROM[CPU.PC].."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1]+1)] = (CPU.REGS[callREG(ROM[CPU.PC-1]+1)] - ROM[CPU.PC])%0x10000
 elseif ROM[CPU.PC] == 0x08 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."DIVI "..callREG(CPU.PC-1)..","..ROM[CPU.PC].."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1]+1)] = (CPU.REGS[callREG(ROM[CPU.PC-1]+1)] / ROM[CPU.PC])%0x10000
 elseif ROM[CPU.PC] == 0x09 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."MULI "..callREG(ROM[CPU.PC-1]+1)..","..ROM[CPU.PC].."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1]+1)] = (CPU.REGS[callREG(ROM[CPU.PC-1]+1)] * ROM[CPU.PC])%0x10000
 
 elseif ROM[CPU.PC] == 0x0a then
  CPU.PC = CPU.PC + 1
  if debug == true then
   EMU.logs = EMU.logs.."JMP "..callREG(ROM[CPU.PC]+1).."\t\t"
  end
  CPU.PC = CPU.REGS[callREG(ROM[CPU.PC]+1)]
 elseif ROM[CPU.PC] == 0x0b then
  CPU.PC = CPU.PC + 1
  if debug == true then
   EMU.logs = EMU.logs.."JMPI "..tohex(ROM[CPU.PC]).."\t\t"
  end
  CPU.PC = ROM[CPU.PC]%0x10000
  
 elseif ROM[CPU.PC] == 0x0c then
  CPU.PC = CPU.PC + 1
  if debug == true then
   EMU.logs = EMU.logs.."PNT "..callREG(ROM[CPU.PC]).."\t\t"
  end
  print(CPU.REGS[callREG(ROM[CPU.PC])].." ("..tohex(CPU.REGS[callREG(ROM[CPU.PC])])..")")
  
 elseif ROM[CPU.PC] == 0x0d then
  if debug == true then
   EMU.logs = EMU.logs.."HALT".."\t\t"
  end
  if EMU.softClose == 1 then
   print("HALT AT "..(CPU.PC-1)..":\tCPU HALTED!!!")
   CPU.HALT = true
  else
   error("HALT AT "..(CPU.PC-1)..":\tCPU HALTED!!!")
  end
 elseif ROM[CPU.PC] == 0x0e then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."RAMPOS "..ROM[CPU.PC-1].." "..ROM[CPU.PC].."\t"
  end
  EMU.RAMPOS[ROM[CPU.PC-1]+1] = CPU.REGS[callREG(ROM[CPU.PC])]
 elseif ROM[CPU.PC] == 0x0F then
  CPU.PC = CPU.PC + 3
  if debug == true then
   EMU.logs = EMU.logs.."RAMPOSI "..ROM[CPU.PC-2]..","..ROM[CPU.PC-1]..ROM[CPU.PC].."\t"
  end
  EMU.RAMPOS[ROM[CPU.PC-2]+1] = todec(tohex(ROM[CPU.PC-1])..tohex(ROM[CPU.PC]))
 elseif ROM[CPU.PC] == 0x10 then
  CPU.PC = CPU.PC + 2
  if ROM[CPU.PC]%0x2 == 0 then
   RAMSLOT = todec(tohex(EMU.RAMPOS[4])..tohex(EMU.RAMPOS[3])..tohex(EMU.RAMPOS[2])..tohex(EMU.RAMPOS[1]))%8388609
  else
   RAMSLOT = todec(tohex(EMU.VRAMPOS[4])..tohex(EMU.VRAMPOS[3])..tohex(EMU.VRAMPOS[2])..tohex(EMU.VRAMPOS[1]))%8388609
  end
  if debug == true then
   EMU.logs = EMU.logs.."WRAM "..callREG(ROM[CPU.PC-1])..","..(ROM[CPU.PC]%0x2)..",RAMSLOT:"..RAMSLOT
  end
  WRAM(RAMSLOT, CPU.REGS[callREG(ROM[CPU.PC-1])]%0x100, ROM[CPU.PC]%0x2)
 elseif ROM[CPU.PC] == 0x11 then
  CPU.PC = CPU.PC + 2
  if ROM[CPU.PC]%0x2 == 0 then
   RAMSLOT = todec(tohex(EMU.RAMPOS[4])..tohex(EMU.RAMPOS[3])..tohex(EMU.RAMPOS[2])..tohex(EMU.RAMPOS[1]))%8388609
  else
   RAMSLOT = todec(tohex(EMU.VRAMPOS[4])..tohex(EMU.VRAMPOS[3])..tohex(EMU.VRAMPOS[2])..tohex(EMU.VRAMPOS[1]))%8388609
  end
  if debug == true then
   EMU.logs = EMU.logs.."RRAM "..callREG(ROM[CPU.PC-1])..","..(ROM[CPU.PC]%0x2)..",RAMSLOT:"..RAMSLOT
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = RRAM(RAMSLOT, ROM[CPU.PC]%0x2)
  
 elseif ROM[CPU.PC] == 0x12 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."SPLIT "..callREG(ROM[CPU.PC-1])..","..callREG(ROM[CPU.PC]).."\t"
  end
  local split = tohex(CPU.REGS[callREG(ROM[CPU.PC])])
  if #tohex(CPU.REGS[callREG(ROM[CPU.PC])]) > 2 then
   if #tohex(CPU.REGS[callREG(ROM[CPU.PC])]) > 3 then
    CPU.REGS[callREG(ROM[CPU.PC-1])] = todec(split[0]..split[1])
    CPU.REGS[callREG(ROM[CPU.PC])] = todec(split[2]..split[3])
   else
    CPU.REGS[callREG(ROM[CPU.PC-1])] = todec(split[0]..split[1])
    CPU.REGS[callREG(ROM[CPU.PC])] = todec(split[2])
   end
  end
 elseif ROM[CPU.PC] == 0x13 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."COMB "..callREG(ROM[CPU.PC-1])..","..callREG(ROM[CPU.PC])..",combined:"..tohex(CPU.REGS[callREG(ROM[CPU.PC-1])])..tohex(CPU.REGS[callREG(ROM[CPU.PC])])
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = todec(tohex(CPU.REGS[callREG(ROM[CPU.PC-1])])..tohex(CPU.REGS[callREG(ROM[CPU.PC])]))
 
 elseif ROM[CPU.PC] == 0x14 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."OR "..callREG(ROM[CPU.PC-1])..","..callREG(ROM[CPU.PC]).."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = bit.bor(CPU.REGS[callREG(ROM[CPU.PC-1])],CPU.REGS[callREG(ROM[CPU.PC])])
 elseif ROM[CPU.PC] == 0x15 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."AND "..callREG(ROM[CPU.PC-1])..","..callREG(ROM[CPU.PC]).."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = bit.band(CPU.REGS[callREG(ROM[CPU.PC-1])],CPU.REGS[callREG(ROM[CPU.PC])])
 elseif ROM[CPU.PC] == 0x16 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."XOR "..callREG(ROM[CPU.PC-1])..","..callREG(ROM[CPU.PC]).."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = bit.bxor(CPU.REGS[callREG(ROM[CPU.PC-1])],CPU.REGS[callREG(ROM[CPU.PC])])
 elseif ROM[CPU.PC] == 0x17 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."NOT "..callREG(ROM[CPU.PC-1])..","..callREG(ROM[CPU.PC]).."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = bit.bnot(CPU.REGS[callREG(ROM[CPU.PC-1])],CPU.REGS[callREG(ROM[CPU.PC])])
  
 elseif ROM[CPU.PC] == 0x18 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."ORI "..callREG(ROM[CPU.PC-1])..","..ROM[CPU.PC].."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = bit.bor(CPU.REGS[callREG(ROM[CPU.PC-1])],ROM[CPU.PC])
 elseif ROM[CPU.PC] == 0x19 then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."ANDI "..callREG(ROM[CPU.PC-1])..","..ROM[CPU.PC].."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = bit.band(CPU.REGS[callREG(ROM[CPU.PC-1])],ROM[CPU.PC])
 elseif ROM[CPU.PC] == 0x1a then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."XORI "..callREG(ROM[CPU.PC-1])..","..ROM[CPU.PC].."\t"
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = bit.bxor(CPU.REGS[callREG(ROM[CPU.PC-1])],ROM[CPU.PC])
 elseif ROM[CPU.PC] == 0x1b then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."NOTI "..callREG(ROM[CPU.PC-1])..","..ROM[CPU.PC]
  end
  CPU.REGS[callREG(ROM[CPU.PC-1])] = bit.bnot(CPU.REGS[callREG(ROM[CPU.PC-1])],ROM[CPU.PC])
  
 elseif ROM[CPU.PC] == 0x1c then
  CPU.PC = CPU.PC + 1
  if debug == true then
   EMU.logs = EMU.logs.."DVCNUM "..ROM[CPU.PC].."\t"
  end
  --#ports
  --0x0:Contoller0
  --0x1:Contoller1
  --0x2:GPU
  --0x3:Sound
  --0x4:Network(connection between consoles)
  --[v]:...
  DeviceID = ROM[CPU.PC]%0x10
  
 elseif ROM[CPU.PC] == 0x1d then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."SNDDVC "..ROM[CPU.PC-1]..","..callREG(ROM[CPU.PC]).."\t"
  end
  --print("DeviceID: "..DeviceID,ROM[CPU.PC-1],callREG(ROM[CPU.PC]))
  if DeviceID == 0x0 or DeviceID == 0x1 then --CONTROLLER 0/1
   print("NOTTICE: can't send data to controllers(0/1)")
  elseif DeviceID == 0x2 then --GPU
   if ROM[CPU.PC-1] == 0x00 then --SET X
    GPU.X = tonumber(CPU.REGS[callREG(ROM[CPU.PC])])
	--print(GPU.X)
   elseif ROM[CPU.PC-1] == 0x01 then --SET Y
    GPU.Y = tonumber(CPU.REGS[callREG(ROM[CPU.PC])])
	--print(GPU.Y)
   elseif ROM[CPU.PC-1] == 0x02 then --SET R
    GPU.R = tonumber(CPU.REGS[callREG(ROM[CPU.PC])])
	--print(GPU.R)
   elseif ROM[CPU.PC-1] == 0x03 then --SET G
    GPU.G = tonumber(CPU.REGS[callREG(ROM[CPU.PC])])
	--print(GPU.G)
   elseif ROM[CPU.PC-1] == 0x04 then --SET B
    GPU.B = tonumber(CPU.REGS[callREG(ROM[CPU.PC])])
	--print(GPU.B)
   elseif ROM[CPU.PC-1] == 0x05 then --plot
    --print(GPU.X, GPU.Y, GPU.R, GPU.G, GPU.B)
	love.graphics.setCanvas(GPU.buffer)
	love.graphics.setColor(GPU.R, GPU.G, GPU.B)
    love.graphics.rectangle("fill", GPU.X, GPU.Y, 1, 1)
	love.graphics.setCanvas()
   elseif ROM[CPU.PC-1] == 0x06 then --update
    GPU.screen = (GPU.buffer)
    --print(GPU.X, GPU.Y, GPU.R, GPU.G, GPU.B)
	GPU.update = true
   else
    print("NOTTIC: Unknown device Opcode: "..ROM[CPU.PC-1].. "(for DeviceID:"..DeviceID..")")
   end
  else
   print("NOTTIC: Unknown deviceID: "..DeviceID)
  end
  
 elseif ROM[CPU.PC] == 0x1e then
  CPU.PC = CPU.PC + 2
  if debug == true then
   EMU.logs = EMU.logs.."RCVDVC "..ROM[CPU.PC-1]..","..callREG(ROM[CPU.PC]).."\t"
  end
  if DeviceID == 0x0 then --CONTROLLER 0
   
  elseif DeviceID == 0x1 then --CONTROLLER 1
   
  elseif DeviceID == 2 then --GPU
   if ROM[CPU.PC-1] == 0x00 then --READ PIXEL
    GPUread(X,Y,REGS[callREG(ROM[CPU.PC])])
   end
  end
 elseif ROM[CPU.PC] == 0x1f then
  CPU.PC = CPU.PC + 4
  l = ROM[CPU.PC]
  if debug == true then
   --print("CMP "..ROM[CPU.PC-3]..","..callREG(ROM[CPU.PC-2])..","..callREG(ROM[CPU.PC-1])..","..ROM[CPU.PC])
   EMU.logs = EMU.logs.."CMP "..ROM[CPU.PC-3]..","..callREG(ROM[CPU.PC-2])..","..callREG(ROM[CPU.PC-1])..","..ROM[CPU.PC].."\t"
  end
  if ROM[CPU.PC-3] == 0 then
   if CPU.REGS[callREG(ROM[CPU.PC-2])] == CPU.REGS[callREG(ROM[CPU.PC-1])] then
    ----print("true")
   else
    ----print("false")
    CPU.PC = CPU.PC + l
   end
  elseif ROM[CPU.PC-3] == 1 then
   if CPU.REGS[callREG(ROM[CPU.PC-2])] < CPU.REGS[callREG(ROM[CPU.PC-1])] then
    --print("true")
   else
    --print("false")
    CPU.PC = CPU.PC + l
   end
  elseif ROM[CPU.PC-3] == 2 then
   if CPU.REGS[callREG(ROM[CPU.PC-2])] > CPU.REGS[callREG(ROM[CPU.PC-1])] then
    --print("true")
   else
    --print("false")
    CPU.PC = CPU.PC + l
   end
  elseif ROM[CPU.PC-3] == 3 then
   if CPU.REGS[callREG(ROM[CPU.PC-2])] ~= CPU.REGS[callREG(ROM[CPU.PC-1])] then
    --print("true")
   else
    --print("false")
    CPU.PC = CPU.PC + l
   end
  end
  
 elseif ROM[CPU.PC] == 0x20 then
  
 else
  error("Unknowned OperationCode: "..ROM[CPU.PC])
 end
 if debug == true then
  EMU.logs = EMU.logs.."\t|\t"
  for i=0,7 do
   EMU.logs = EMU.logs..callREG(i)..":"..tohex(CPU.REGS[callREG(i)]).."\t    "
  end
  print(EMU.logs)
  EMU.logs = ""
 end
 CPU.PC = CPU.PC + 1
 CPU.commands = CPU.commands + 1
 if math.floor(EMU.timesec)+1 == math.floor(love.timer.getTime()) then
  --print("IPS: "..CPU.commands)
  EMU.IPS = CPU.commands
  CPU.commands = 0
  if CPU.commands >= MB.HertzLimmit then
   while math.floor(EMU.timesec)+1 == math.floor(love.timer.getTime()) do
   end
  end
  EMU.timesec = love.timer.getTime()
 end
end