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

function exec(data)
 if data[CPU.PC] then
  --print(CPU.PC-1, data[CPU.PC])
  if debug == true then
   EMU.logs = EMU.logs..tohex(CPU.PC-1).."/"..(CPU.PC-1)..":\tExecuting "..tohex(data[CPU.PC])..":\t"
  end
  if data[CPU.PC] == 0x00 then
   if debug == true then
    EMU.logs = EMU.logs.."NOP\t\t"
   end
  elseif data[CPU.PC] == 0x01 then
   CPU.PC = CPU.PC + 3
   if debug == true then
    EMU.logs = EMU.logs.."LOAD "..data[CPU.PC-2]..","..(tohex(data[CPU.PC-1])..tohex(data[CPU.PC])).."\t"
   end
   CPU.REGS[callREG(data[CPU.PC-2])] = tonumber(tohex(data[CPU.PC-1])..tohex(data[CPU.PC]),16)
  elseif data[CPU.PC] == 0x02 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."ADD "..callREG(data[CPU.PC-1])..","..callREG(data[CPU.PC]).."\t\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = (CPU.REGS[callREG(data[CPU.PC-1])] + CPU.REGS[callREG(data[CPU.PC])])%0x10000
  elseif data[CPU.PC] == 0x03 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."SUB "..callREG(data[CPU.PC-1])..","..callREG(data[CPU.PC]).."\t\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = (CPU.REGS[callREG(data[CPU.PC-1])] - CPU.REGS[callREG(data[CPU.PC])])%0x10000
  elseif data[CPU.PC] == 0x04 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."DIV "..callREG(data[CPU.PC-1])..","..callREG(data[CPU.PC]).."\t\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = (CPU.REGS[callREG(data[CPU.PC-1])] / CPU.REGS[callREG(data[CPU.PC])])%0x10000
  elseif data[CPU.PC] == 0x05 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."MUL "..callREG(data[CPU.PC-1])..","..callREG(data[CPU.PC]).."\t\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = (CPU.REGS[callREG(data[CPU.PC-1])] * CPU.REGS[callREG(data[CPU.PC])])%0x10000
  
  elseif data[CPU.PC] == 0x06 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."ADDI "..callREG(data[CPU.PC]-1)..","..data[CPU.PC].."\t\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = (CPU.REGS[callREG(data[CPU.PC-1])] + data[CPU.PC])%0x10000
  elseif data[CPU.PC] == 0x07 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."SUBI "..callREG(CPU.PC-1)..","..data[CPU.PC].."\t\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1]+1)] = (CPU.REGS[callREG(data[CPU.PC-1]+1)] - data[CPU.PC])%0x10000
  elseif data[CPU.PC] == 0x08 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."DIVI "..callREG(CPU.PC-1)..","..data[CPU.PC].."\t\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1]+1)] = (CPU.REGS[callREG(data[CPU.PC-1]+1)] / data[CPU.PC])%0x10000
  elseif data[CPU.PC] == 0x09 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."MULI "..callREG(data[CPU.PC-1]+1)..","..data[CPU.PC].."\t\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1]+1)] = (CPU.REGS[callREG(data[CPU.PC-1]+1)] * data[CPU.PC])%0x10000
  
  elseif data[CPU.PC] == 0x0a then
   CPU.PC = CPU.PC + 1
   if debug == true then
    EMU.logs = EMU.logs.."JMP "..callREG(data[CPU.PC]).."\t\t"
   end
   CPU.PC = CPU.REGS[callREG(data[CPU.PC])]
  elseif data[CPU.PC] == 0x0b then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."JMPI "..tohex(data[CPU.PC-1])..tohex(data[CPU.PC]).."\t"
   end
   CPU.PC = todec(tohex(data[CPU.PC-1])..tohex(data[CPU.PC]))
   
  elseif data[CPU.PC] == 0x0c then
   CPU.PC = CPU.PC + 1
   if debug == true then
    EMU.logs = EMU.logs.."PNT "..callREG(data[CPU.PC]).."\t\t"
   end
   print(CPU.REGS[callREG(data[CPU.PC])].." ("..tohex(CPU.REGS[callREG(data[CPU.PC])])..")")
   
  elseif data[CPU.PC] == 0x0d then
   CPU.PC = CPU.PC + 1
   if debug == true then
    EMU.logs = EMU.logs.."HALT".."\t"..data[CPU.PC].."\t"
   end
   --[[HALT-DETAILS]]--
   --0: nothing                                [N/A]
   --1: stop running everything                [CPU]
   --2: stops BIOS from running and starts     [BIOS]
   --3: resets the Audio                       [AUDIO]
   --4: resets the Screen                      [VIDEO]
   --5: resets the Input                       [INPUT]
   --6: resets Network System                  [NETWORK]
   --7: stops everything and prints PC         [CPU]
   --8: nothing                                [N/A]
   --9: nothing                                [N/A]
   --A: nothing                                [N/A]
   --B: nothing                                [N/A]
   --C: nothing                                [N/A]
   --D: nothing                                [N/A]
   --E: nothing                                [N/A]
   --F: resets everything(restarts the emu)    [EMU]
   CPU.flags.halt = data[CPU.PC]
   if data[CPU.PC] == 1 then
    local halt = "HALT AT "..(CPU.PC-2)..":\tCPU HALTED!!!"
    if EMU.softClose == 1 then
     print(halt)
    else
     error(halt)
    end
   elseif data[CPU.PC] == 0x2 then
    --does nothing here but does something in MAIN.LUA
   elseif data[CPU.PC] == 0x3 then
    --reset audio REGS
   elseif data[CPU.PC] == 0x4 then
    --reset screen and GPU REGS
   elseif data[CPU.PC] == 0x5 then
    --reset network ARGS and restart
   elseif data[CPU.PC] == 0x6 then
    
   elseif data[CPU.PC] == 0x7 then
    
   elseif data[CPU.PC] == 0x8 then
    
   elseif data[CPU.PC] == 0x9 then
    
   elseif data[CPU.PC] == 0xa then
    
   elseif data[CPU.PC] == 0xb then
    
   elseif data[CPU.PC] == 0xc then
    
   elseif data[CPU.PC] == 0xd then
    
   elseif data[CPU.PC] == 0xe then
    
   elseif data[CPU.PC] == 0xf then
    start() --resets all the vars. to default to auth reboot
   end
  elseif data[CPU.PC] == 0x0e then
   CPU.PC = CPU.PC + 3
   if debug == true then
    EMU.logs = EMU.logs.."RAMPOS "..data[CPU.PC-1]..","..callREG(data[CPU.PC]).."\t"
    print(">",todec(tohex(EMU.RAMPOS[4])..tohex(EMU.RAMPOS[3])..tohex(EMU.RAMPOS[2])..tohex(EMU.RAMPOS[1]))%0x8000000)
   end
   EMU.RAMPOS[data[CPU.PC-1]] = CPU.REGS[callREG(data[CPU.PC])]
  elseif data[CPU.PC] == 0x0F then
   CPU.PC = CPU.PC + 3
   if debug == true then
    EMU.logs = EMU.logs.."RAMPOSI "..data[CPU.PC-2]..","..tohex(data[CPU.PC-1])..tohex(data[CPU.PC]).."\t"
    print(">",todec(tohex(EMU.RAMPOS[4])..tohex(EMU.RAMPOS[3])..tohex(EMU.RAMPOS[2])..tohex(EMU.RAMPOS[1]))%0x8000000)
   end
   EMU.RAMPOS[data[CPU.PC-2]+1] = todec(tohex(data[CPU.PC-1])..tohex(data[CPU.PC]))
  elseif data[CPU.PC] == 0x10 then
   CPU.PC = CPU.PC + 2
   if data[CPU.PC]%0x2 == 0 then
    RAMSLOT = todec(tohex(EMU.RAMPOS[4])..tohex(EMU.RAMPOS[3])..tohex(EMU.RAMPOS[2])..tohex(EMU.RAMPOS[1]))%0x8000000
   else
    RAMSLOT = todec(tohex(EMU.VRAMPOS[4])..tohex(EMU.VRAMPOS[3])..tohex(EMU.VRAMPOS[2])..tohex(EMU.VRAMPOS[1]))%0x8000000
   end
   if EMU.BIOSrunning == true then
    RAMSLOT = RAMSLOT + 0x7FF0000
   end
   if debug == true then
    EMU.logs = EMU.logs.."WRAM "..callREG(data[CPU.PC-1])..","..(data[CPU.PC]%0x2)..", RAMSLOT: "..RAMSLOT
   end
   WRAM(RAMSLOT, CPU.REGS[callREG(data[CPU.PC-1])]%0x100, data[CPU.PC]%0x2)
  elseif data[CPU.PC] == 0x11 then
   CPU.PC = CPU.PC + 2
   if data[CPU.PC]%0x2 == 0 then
    RAMSLOT = todec(tohex(EMU.RAMPOS[4])..tohex(EMU.RAMPOS[3])..tohex(EMU.RAMPOS[2])..tohex(EMU.RAMPOS[1]))%0x8000000
   else
    RAMSLOT = todec(tohex(EMU.VRAMPOS[4])..tohex(EMU.VRAMPOS[3])..tohex(EMU.VRAMPOS[2])..tohex(EMU.VRAMPOS[1]))%0x8000000
   end
   if data[CPU.PC]%0x2 == 1 and RAMSLOT >= 0x8000000 then
    while true do
     if RAMSLOT >= 0x8000000 then
      RAMSLOT = RAMSLOT - 0x8000000
     else
      break       
     end
    end
   end
   if EMU.BIOSrunning == true then
    RAMSLOT = RAMSLOT + 0x7FF0000
   end
   if debug == true then
    EMU.logs = EMU.logs.."RRAM "..callREG(data[CPU.PC-1])..","..(data[CPU.PC]%0x2)..", RAMSLOT: "..RAMSLOT
   end
--   for i=RAMSLOT-10,RAMSLOT+10 do
--    print("RAMSLOT:"..tostring(RAMSLOT),RRAM(i+1, data[CPU.PC]%0x2))
--   end
   local temp = RRAM(RAMSLOT+1, data[CPU.PC]%0x2)
   if debug == true then
    if data[CPU.PC] == 0 then
     print("RAM Output: 0x"..tohex(temp))
    else
     print("VRAM Output: 0x"..tohex(temp))
    end
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = temp
   
   --POS:134152194
   --MAX:134217728
  elseif data[CPU.PC] == 0x12 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."SPLIT "..callREG(data[CPU.PC-1])..","..callREG(data[CPU.PC]).."\t"
   end
   local split = tohex(CPU.REGS[callREG(data[CPU.PC])])
   if #tohex(CPU.REGS[callREG(data[CPU.PC])]) > 2 then
    if #tohex(CPU.REGS[callREG(data[CPU.PC])]) > 3 then
     CPU.REGS[callREG(data[CPU.PC-1])] = todec(split[0]..split[1])
     CPU.REGS[callREG(data[CPU.PC])] = todec(split[2]..split[3])
    else
     CPU.REGS[callREG(data[CPU.PC-1])] = todec(split[0]..split[1])
     CPU.REGS[callREG(data[CPU.PC])] = todec(split[2])
    end
   end
  elseif data[CPU.PC] == 0x13 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."COMB "..callREG(data[CPU.PC-1])..","..callREG(data[CPU.PC])..",combined:"..tohex(CPU.REGS[callREG(data[CPU.PC-1])])..tohex(CPU.REGS[callREG(data[CPU.PC])])
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = todec(tohex(CPU.REGS[callREG(data[CPU.PC-1])])..tohex(CPU.REGS[callREG(data[CPU.PC])]))
  
  elseif data[CPU.PC] == 0x14 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."OR "..callREG(data[CPU.PC-1])..","..callREG(data[CPU.PC]).."\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = bit.bor(CPU.REGS[callREG(data[CPU.PC-1])],CPU.REGS[callREG(data[CPU.PC])])
  elseif data[CPU.PC] == 0x15 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."AND "..callREG(data[CPU.PC-1])..","..callREG(data[CPU.PC]).."\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = bit.band(CPU.REGS[callREG(data[CPU.PC-1])],CPU.REGS[callREG(data[CPU.PC])])
  elseif data[CPU.PC] == 0x16 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."XOR "..callREG(data[CPU.PC-1])..","..callREG(data[CPU.PC]).."\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = bit.bxor(CPU.REGS[callREG(data[CPU.PC-1])],CPU.REGS[callREG(data[CPU.PC])])
  elseif data[CPU.PC] == 0x17 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."NOT "..callREG(data[CPU.PC-1])..","..callREG(data[CPU.PC]).."\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = bit.bnot(CPU.REGS[callREG(data[CPU.PC-1])],CPU.REGS[callREG(data[CPU.PC])])
   
  elseif data[CPU.PC] == 0x18 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."ORI "..callREG(data[CPU.PC-1])..","..data[CPU.PC].."\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = bit.bor(CPU.REGS[callREG(data[CPU.PC-1])],data[CPU.PC])
  elseif data[CPU.PC] == 0x19 then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."ANDI "..callREG(data[CPU.PC-1])..","..data[CPU.PC].."\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = bit.band(CPU.REGS[callREG(data[CPU.PC-1])],data[CPU.PC])
  elseif data[CPU.PC] == 0x1a then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."XORI "..callREG(data[CPU.PC-1])..","..data[CPU.PC].."\t"
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = bit.bxor(CPU.REGS[callREG(data[CPU.PC-1])],data[CPU.PC])
  elseif data[CPU.PC] == 0x1b then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."NOTI "..callREG(data[CPU.PC-1])..","..data[CPU.PC]
   end
   CPU.REGS[callREG(data[CPU.PC-1])] = bit.bnot(CPU.REGS[callREG(data[CPU.PC-1])],data[CPU.PC])
   
  elseif data[CPU.PC] == 0x1c then
   CPU.PC = CPU.PC + 1
   if debug == true then
    EMU.logs = EMU.logs.."DVCNUM "..data[CPU.PC].."\t"
   end
   --#ports
   --0x0:Contoller0
   --0x1:Contoller1
   --0x2:GPU
   --0x3:Sound
   --0x4:Network(connection between consoles)
   --[v]:...
   DeviceID = data[CPU.PC]%0x10
   
  elseif data[CPU.PC] == 0x1d then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."SNDDVC "..data[CPU.PC-1]..","..callREG(data[CPU.PC]).."\t"
   end
   --print("DeviceID: "..DeviceID,data[CPU.PC-1],callREG(data[CPU.PC]))
   if DeviceID == 0x0 or DeviceID == 0x1 then --CONTROLLER 0/1
    print("NOTTICE: can't send data to controllers(0/1)")
   elseif DeviceID == 0x2 then --GPU
    if data[CPU.PC-1] == 0x00 then --SET X (16-BIT Input)
     GPU.X = tonumber(CPU.REGS[callREG(data[CPU.PC])])
     --print(GPU.X)
    elseif data[CPU.PC-1] == 0x01 then --SET Y (16-BIT Input)
     GPU.Y = tonumber(CPU.REGS[callREG(data[CPU.PC])])
     --print(GPU.Y)
    elseif data[CPU.PC-1] == 0x02 then --SET R (8-BIT Input)
     GPU.R = tonumber(CPU.REGS[callREG(data[CPU.PC])])
     --print(GPU.R)
    elseif data[CPU.PC-1] == 0x03 then --SET G (8-BIT Input)
     GPU.G = tonumber(CPU.REGS[callREG(data[CPU.PC])])
     --print(GPU.G)
    elseif data[CPU.PC-1] == 0x04 then --SET B (8-BIT Input)
     GPU.B = tonumber(CPU.REGS[callREG(data[CPU.PC])])
     --print(GPU.B)
    elseif data[CPU.PC-1] == 0x05 then --SET COLOR-PALLET (4-BIT Input)
     GPU.CP.R[data[CPU.PC]] = GPU.R
     GPU.CP.G[data[CPU.PC]] = GPU.G
     GPU.CP.B[data[CPU.PC]] = GPU.B
    elseif data[CPU.PC-1] == 0x06 then --plot (8-BIT Input/color-pallet)
     --print(GPU.X, GPU.Y, GPU.R, GPU.G, GPU.B)
     love.graphics.setCanvas(GPU.buffer)
     if data[CPU.PC] == 0 then
      love.graphics.setColor(GPU.R, GPU.G, GPU.B)
     else
      love.graphics.setColor(GPU.CP.R[data[CPU.PC]], GPU.CP.G[data[CPU.PC]], GPU.CP.B[data[CPU.PC]])
     end
     love.graphics.rectangle("fill", GPU.X, GPU.Y, 1, 1)
     love.graphics.setCanvas()
    elseif data[CPU.PC-1] == 0x07 then --update
     --GPU.screen = (GPU.buffer)
     -- create a new canvas of the same dimensions beforehand, and then:
     love.graphics.push("all")
     love.graphics.setCanvas(GPU.screen)
     love.graphics.setBlendMode("replace", "premultiplied")
     if Settings.Menu.ShowMenuBar == true then
      love.graphics.draw(GPU.buffer, 0, 0)
     else
      love.graphics.draw(GPU.buffer, 0, 20)
     end
     love.graphics.pop()
     love.graphics.setCanvas()
     --print(GPU.screen, GPU.buffer, GPU.X, GPU.Y, GPU.R, GPU.G, GPU.B)
     GPU.update = true
    else
     print("Emu Error: "..(CPU.PC-1)..": Unknown Device Opcode: "..data[CPU.PC-1].. "(for DeviceID:"..DeviceID..")")
     CPU.flags.halt = 1
    end
   else
    print("Emu Error: "..(CPU.PC-1)..": Unknown DeviceID: "..DeviceID)
    CPU.flags.halt = 1
   end
   
  elseif data[CPU.PC] == 0x1e then
   CPU.PC = CPU.PC + 2
   if debug == true then
    EMU.logs = EMU.logs.."RCVDVC "..data[CPU.PC-1]..","..callREG(data[CPU.PC]).."\t"
   end
   if DeviceID == 0x0 then --CONTROLLER 0
     DVCtmp = get_input(0,data[CPU.PC+1])*1
   elseif DeviceID == 0x1 then --CONTROLLER 1
    DVCtmp = get_input(1,data[CPU.PC+1])*1
   elseif DeviceID == 2 then --GPU
    if data[CPU.PC-1] == 0x00 then --READ PIXEL
     DVCtmp = GPUread(X,Y,REGS[callREG(data[CPU.PC])])
    elseif data[CPU.PC-1] == 0x01 then --GET WIDTH
     DVCtmp = SW
    elseif data[CPU.PC-1] == 0x02 then --GET HIGHT
     DVCtmp = SH
    else
     print("Emu Error: "..(CPU.PC-1)..": Unknown Device Opcode: "..data[CPU.PC-1].. "(for DeviceID:"..DeviceID..")")
     CPU.flags.halt = 1
    end
    if DVCtmp then
     CPU.REGS[callREG(data[CPU.PC])] = DVCtmp
    end
   else
    print("Emu Error: "..(CPU.PC-1)..": Unknown DeviceID: "..DeviceID)
    CPU.flags.halt = 1
   end
   
  elseif data[CPU.PC] == 0x1f then
   CPU.PC = CPU.PC + 4
   l = data[CPU.PC]
   if debug == true then
    --print("CMP "..data[CPU.PC-3]..","..callREG(data[CPU.PC-2])..","..callREG(data[CPU.PC-1])..","..data[CPU.PC])
    EMU.logs = EMU.logs.."CMP "..data[CPU.PC-3]..","..callREG(data[CPU.PC-2])..","..callREG(data[CPU.PC-1])..", GOTO:"..callREG(data[CPU.PC])
   end
   if data[CPU.PC-3] == 0 then
    if CPU.REGS[callREG(data[CPU.PC-2])] == CPU.REGS[callREG(data[CPU.PC-1])] then
     if debug == true then
      print("true")
     end
     CPU.PC = CPU.REGS[callREG(data[CPU.PC])]
    else
     if debug == true then
      print("false")
     end
    end
   elseif data[CPU.PC-3] == 1 then
    if CPU.REGS[callREG(data[CPU.PC-2])] < CPU.REGS[callREG(data[CPU.PC-1])] then
     if debug == true then
      print("true")
     end
     CPU.PC = CPU.REGS[callREG(data[CPU.PC])]
    else
     if debug == true then
      print("false")
     end
    end
   elseif data[CPU.PC-3] == 2 then
    if CPU.REGS[callREG(data[CPU.PC-2])] > CPU.REGS[callREG(data[CPU.PC-1])] then
     if debug == true then
      print("true")
     end
     CPU.PC = CPU.REGS[callREG(data[CPU.PC])]
    else
     if debug == true then
      print("false")
     end
    end
   elseif data[CPU.PC-3] == 3 then
    if CPU.REGS[callREG(data[CPU.PC-2])] ~= CPU.REGS[callREG(data[CPU.PC-1])] then
     if debug == true then
      print("true")
     end
     CPU.PC = CPU.REGS[callREG(data[CPU.PC])]
    else
     if debug == true then
      print("false")
     end
    end
   end
   
  else
   print("Emu Error: "..(CPU.PC-1)..": Unknowned OperationCode: "..data[CPU.PC])
   CPU.flags.halt = 1
  end
  if debug == true then
   EMU.logs = EMU.logs.."\t|\t"
   for i=0,7 do
--    print(callREG(i),CPU.REGS[callREG(i)])
    EMU.logs = EMU.logs..callREG(i)..":"..tohex(CPU.REGS[callREG(i)]).."\t    "
   end
   print(EMU.logs)
   EMU.logs = ""
  end
  CPU.PC = CPU.PC + 1
  CPU.commands = CPU.commands + 1
  if math.floor(EMU.timesec)+1 == math.floor(love.timer.getTime()) then
   EMU.IPS = CPU.commands
   CPU.commands = 0
   if CPU.commands >= MB.HertzLimmit then
    while math.floor(EMU.timesec)+1 == math.floor(love.timer.getTime()) do
    end
   end
   EMU.timesec = love.timer.getTime()
  end
 else
  CPU.flags.halt = 1
  print("EMU Error: "..tostring(CPU.PC)..": PC out of bounds in ROM")
 end
end
--PC = 0x04
--renders 0x04
--shows as 0x05
