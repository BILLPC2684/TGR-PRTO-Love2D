--###########################--
--###########################--
--#     THE GAME RAZER      #--
--#  MAIN STARTUP PROGRAM   #--
--#    **DO NOT EDIT**      #--
--###########################--
--###########################--
--###########################--

--RUN Function--
function love.run()
 if love.load then love.load(arg) end
  -- We don't want the first frame's dt to include time taken by love.load.
  if love.timer then love.timer.step() end
  local dt = 0
  -- Main loop time.
  while true do
   -- Process events.
  if love.event then
   love.event.pump()
   for name, a,b,c,d,e,f in love.event.poll() do
    if name == "quit" then
     if not love.quit or not love.quit() then
      return a
     end
    end
    love.handlers[name](a,b,c,d,e,f)
   end
  end
  -- Update dt, as we'll be passing it to update
  if love.timer then
   love.timer.step()
   dt = love.timer.getDelta()
   --love.timer.sleep(0.001)
  end
  -- Call update and draw
  if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
  if love.graphics and love.graphics.isActive() then
   --love.graphics.clear(love.graphics.getBackgroundColor())
   --love.graphics.origin()
   if love.draw then love.draw() end
   --love.graphics.present()
  end
 end
end
--[[function love.run()
 love.load(arg)
 love.graphics.clear(love.graphics.getBackgroundColor())
 love.graphics.present()
 -- Main loop time.
 while true do
  love.timer.step()
  -- Call update and draw
  love.update()
  --love.graphics.clear(love.graphics.getBackgroundColor())
  --love.graphics.origin()
  love.draw()
  --love.graphics.present()
  --if love.timer then love.timer.sleep(0.001) end
 end
end]]--

--cd "./Desktop/prototype emulation"
--lovec ./ <ROM>

--VAR Function--
getmetatable('').__index = function(str,i)
 if type(i) == 'number' then
  return string.sub(str,i,i)
 else
  return string[i]
 end
end

--Loading Function--
function load(filename)
 local File = io.open(filename,"rb")
 local data = File:read(("*a"))
 File:close()
 content = {}
 for i=1,#data do
  table.insert(content, data:sub(i, i):byte())
 end
 return content
end

function love.load(args)
 version = "PRTO v0.76c"
 Settings = {Menu = {}, Video = {}, Emulation = {}, Sound = {}, Controller = {}}
 Settings.Controller = {takeinput = {}, A = {}, B = {}, C = {}, X = {}, Y = {}, Z = {}, L = {}, R = {}, START = {}, SELECT = {}, UP = {}, DOWN = {}, LEFT = {}, RIGHT = {}}
 print("LOADING \""..version.."\"...")
 import = {"./Settings","./bin/init","./bin/input","./bin/cpu"}
 debug = false
 timer = false
 RAMshow = 0
 RAMrender = 0
 for i=1,#import do
  require(import[i])
 end
 
 print("--[[LOADING-BIOS]]--")
 BIOSFN = "./bin/BIOS.bin"
 BIOS = load(BIOSFN)
 local tmp = ""
 tmp = tmp..".____________________________________________________.\n"
 tmp = tmp.."|BIOS|00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F|\n"
 tmp = tmp.."|----|-----------------------------------------------|\n"
 tmp = tmp.."|0000|"
 local j = 1
 for i=1,#BIOS do
  if j > 15 then
   tmp = tmp..tohex(BIOS[i]).."|\n|"
   if #tohex(i) == 2 then
    tmp = tmp.."00"..tohex(i).."|"
   elseif #tohex(i) == 3 then
    tmp = tmp.."0"..tohex(i).."|"
   else
    tmp = tmp..tohex(i).."|"
   end
   j = 0
  else
   tmp = tmp..tohex(BIOS[i]).." "
  end
  j = j + 1
 end
 if j > 0 then
  for i=j,15 do
   tmp = tmp.."-- "
  end
  tmp = tmp.."--|\n"
 end
 tmp = tmp.."|____|_______________________________________________|"
 print(string.upper(tmp))
 print("LENGTH:"..#BIOS)
 print("--[[END-OF-BIOS]]--")
 
 print("--[[LOADING-ROM]]--")
 ROMFN = args[2]
 if not ROMFN then
  print("EMU ERROR: Please include a ROM when executing via terminal...")
  os.exit()
 end
 ROM = load(ROMFN)
 if #ROM < 6 then
  print("EMU ERROR: The BIOS detected the ROM is too small to be executed must be atlease 6 bytes long...")
  CPU.flags.halt = 0x1
 else
  print("\n\\BIOS: ROMCheck info:")
  print(" \\Type:",ROM[1])
  print(" \\Name:",string.char(ROM[2])..string.char(ROM[3])..string.char(ROM[4]))
  --[[0:ROM_TYPE | 1-3:NameCheck]]--
  WRAM(0x7FF0001, ROM[1], 0)
  WRAM(0x7FF0002, ROM[2], 0)
  WRAM(0x7FF0003, ROM[3], 0)
  WRAM(0x7FF0004, ROM[4], 0)
  local tmp = ""
  tmp = tmp..".____________________________________________________.\n"
  tmp = tmp.."|ROM |00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F|\n"
  tmp = tmp.."|----|-----------------------------------------------|\n"
  tmp = tmp.."|0000|"
  local j = 1
  for i=1,#ROM do
   if j > 15 then
    tmp = tmp..tohex(ROM[i]).."|\n|"
    if #tohex(i) == 2 then
     tmp = tmp.."00"..tohex(i).."|"
    elseif #tohex(i) == 3 then
     tmp = tmp.."0"..tohex(i).."|"
    else
     tmp = tmp..tohex(i).."|"
    end
    j = 0
   else
    tmp = tmp..tohex(ROM[i]).." "
   end
   j = j + 1
  end
  if j > 0 then
   for i=j,15 do
    tmp = tmp.."-- "
   end
   tmp = tmp.."--|\n"
  end
  tmp = tmp.."|____|_______________________________________________|"
  print(string.upper(tmp))
  print("LENGTH:"..#ROM)
--  for i=1,#ROM do
--   io.write(string.char(ROM[i])..",")
--  end
  
  --print(ROM[1])
  --print(ROM[#ROM])
  print("--[[END-OF-ROM]]--")
  --[[END-OF-LOADING-ROM]]--
  print("EMU: Executing BIOS...")
 end
 for i=0, #args do
  if args[i] == "--debug" then
   debug = true
  elseif args[i] == "--speed" or args[i] == "--timer" then
   sptest = love.timer.getTime()
   print("[>] Started BIOS timer...")
  end
 end
 frame = 0
 FPS = 0
 RF = 0
 MAXIPS = 0
 init_input(0)
 init_input(1)
 
 programhalt = false --for when the program softcloses
 collectgarbage()
end

function love.update(dt)
 if input.controller0 then
  get_input(0)
 end
 if input.controller1 then
  get_input(1)
 end
 --print(CPU.flags.halt,0x1, CPU.flags.halt ~= 0x1)
 if EMU.IPS < 12000000 and CPU.flags.halt ~= 0x1 then
  if EMU.BIOSrunning == true then
   --print("ROM BIOS: 0x"..tohex(CPU.PC-1),"Opcode 0x"..tohex(BIOS[CPU.PC]))
   exec(BIOS)
  else
   --print("ROM PC: 0x"..tohex(CPU.PC-1),"Opcode 0x"..tohex(ROM[CPU.PC]))
   exec(ROM)
  end
 end
 if MAXIPS < EMU.IPS then
  MAXIPS = EMU.IPS
  print("Best IPS: "..MAXIPS)
 end
 if CPU.flags.halt == 0x2 then
  if EMU.BIOSrunning == true then
   print("EMU: HALTING BIOS, Executing ROM...\n")
   if sptest then
    biostime = love.timer.getTime()-sptest
    print("[||] Stopped, time took to calculate the BIOS: "..biostime)
   end
   CPU.HALT = false
   EMU.BIOSrunning = false
   CPU.PC = 0x0004+1
   if sptest then
    sptest = love.timer.getTime()
    print("[>] Started ROM timer...")
   end
  end
 elseif CPU.flags.halt == 0x1 then
  if programhalt == false then
   print("\nEMU: We have detected the main loop has stopped due to a halt...")
   print("This is due to a halt(meaning the program has ended) or is a Emulation Error.")
   print("If there is a Emulation Error check above for what the probblem is in the ROM.")
   print("The screen isn't active but is can still be viewed, to reset the emulator you need to goto your\n terminal and press [CTRL] + [C] and relaunch.")
   print("TIP: pressing [CTRL] + [M] will list RAM from RenderRAMPOS + 0x0000 to RenderRAMPOS + 0x02FF")
   print(" same with VideoRAM by pressing [CTRL] + [V]...")
   print(" and pressing [CTRL] + [KeyPad+] or [CTRL] + [KeyPad-] will adjust RenderRAMPOS by 0x10")
   if sptest then
    romtime = love.timer.getTime()-sptest
    print("[||] Stopped, time took to calculate the ROM:  "..romtime)
    print("time took to both calculations: "..biostime+romtime)
   end
  end
  programhalt = true
 end
 if love.keyboard.isDown("lctrl") and love.keyboard.isDown("kp+") and RAMshow == 0 then
  if RAMrender + 0x10 >= 0x8000000 - 0x02FF then
   RAMrender = 0x8000000 - 0x2FF
  else
   RAMrender = RAMrender + 0x10
   print("RenderRAMPOS is now at: 0x"..string.upper(tohex(RAMrender)))
  end
  RAMshow = 100000
 elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("kp-") and RAMshow == 0 then
  if RAMrender - 0x10 <= 0x0 then
   RAMrender = 0x0
  else
   RAMrender = RAMrender - 0x10
   print(("RenderRAMPOS is now at: 0x"..string.upper(tohex(RAMrender))))
  end
  RAMshow = 100000
 elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("m") and RAMshow == 0 then
  local tmp = ""
  tmp = tmp..".____________________________________________________.\n"
  tmp = tmp.."|RAM |00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F|\n"
  tmp = tmp.."|----|-----------------------------------------------|\n"
  tmp = tmp.."|"
  if #tohex(RAMrender) == 2 then
   tmp = tmp.."00"..tohex(RAMrender).."|"
  elseif #tohex(RAMrender) == 3 then
   tmp = tmp.."0"..tohex(RAMrender).."|"
  else
   tmp = tmp..tohex(RAMrender).."|"
  end
  local j = 1
  for i=RAMrender,RAMrender+(0x0300) do
   if j > 15 then
    tmp = tmp..tohex(RRAM(i,0)).."|\n|"
    if #tohex(i+1) == 2 then
     tmp = tmp.."00"..tohex(i+1).."|"
    elseif #tohex(i+1) == 3 then
     tmp = tmp.."0"..tohex(i+1).."|"
    else
     tmp = tmp..tohex(i+1).."|"
    end
    j = 0
   else
    tmp = tmp..tohex(RRAM(i,0)).." "
   end
   j = j + 1
  end
  if j > 0 then
   for i=j,15 do
    tmp = tmp.."-- "
   end
   tmp = tmp.."--|\n"
  end
  tmp = tmp.."|____|_______________________________________________|"
  print(string.upper(tmp))
  RAMshow = 100000
 elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("v") and RAMshow == 0 then
  local tmp = ""
  tmp = tmp..".____________________________________________________.\n"
  tmp = tmp.."|VRAM|00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F|\n"
  tmp = tmp.."|----|-----------------------------------------------|\n"
  tmp = tmp.."|"
  if #tohex(RAMrender) == 2 then
   tmp = tmp.."00"..tohex(RAMrender).."|"
  elseif #tohex(RAMrender) == 3 then
   tmp = tmp.."0"..tohex(RAMrender).."|"
  else
   tmp = tmp..tohex(RAMrender).."|"
  end
  local j = 1
  for i=RAMrender,RAMrender+(0x0300) do
   if j > 15 then
    tmp = tmp..tohex(RRAM(i,0)).."|\n|"
    if #tohex(i+1) == 2 then
     tmp = tmp.."00"..tohex(i+1).."|"
    elseif #tohex(i+1) == 3 then
     tmp = tmp.."0"..tohex(i+1).."|"
    else
     tmp = tmp..tohex(i+1).."|"
    end
    j = 0
   else
    tmp = tmp..tohex(RRAM(i,0)).." "
   end
   j = j + 1
  end
  if j > 0 then
   for i=j,15 do
    tmp = tmp.."-- "
   end
   tmp = tmp.."--|\n"
  end
  tmp = tmp.."|____|_______________________________________________|"
  print(string.upper(tmp))
  RAMshow = 100000
 end
 if RAMshow > 0 then
  RAMshow = RAMshow - 1
 end
end
function love.draw()
 --print(FPS, EMU.frameskip, frame, GPU.update, CPU.HALT)
 if GPU.update == true and CPU.HALT == false then
  if FPS >= EMU.framelimmit then
   local tm = love.timer.getTime()
   while tm == love.timer.getTime() do
    --
   end
   RF = FPS
   FPS = 0
  else
   GPU.update = false
   if EMU.frameskip == frame then
    love.graphics.clear(love.graphics.getBackgroundColor())
    love.graphics.draw(GPU.screen)
    love.graphics.present()
    frame = 0
    FPS = FPS + 1
   else
    frame = frame + 1
   end
  end
 end
 if showFPS == true then
  love.graphics.setColor(0xFF,0xFF,0xFF)
  love.graphics.print("FPS: "..RF.."\t| IPS: "..EMU.IPS.."\t| Best IPS: "..MAXIPS,10,SH-15)
  love.graphics.setColor(0,0,0)
  love.graphics.print("FPS: "..RF.."\t| IPS: "..EMU.IPS.."\t| Best IPS: "..MAXIPS,11,SH-14)
 end
end
