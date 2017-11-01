--###########################--
--###########################--
--#      THE GAME RAZER     #--
--#    INIT STARTUP FILE    #--
--#     **DO NOT EDIT**     #--
--###########################--
--###########################--
--###########################--

--private RAM location 0x7FF0000-0x8000000

--ffi = require('ffi')
--[[RAM Functions]]--
function WRAM(pos, int, type)
 if type == 0 then
  if debug == true then
   print("Writing to RAM with RAMPOS: 0x"..tohex(pos)..", value:  0x"..tohex(int))
  end
  RAM = table.concat{RAM:sub(1,pos), string.char(int), RAM:sub(pos+2)}
 elseif type == 1 then
  if debug == true then
   print("Writing to VRAM with RAMPOS: 0x"..tohex(pos)..", value:  0x"..tohex(int))
  end
  GPU.VRAM = table.concat{GPU.VRAM:sub(1,pos), string.char(int), GPU.VRAM:sub(pos+2)}
 end
 collectgarbage()
end

function RRAM(pos, type)
 print(pos, type, RAM[pos+1])
 if type == 0 then
  if debug == true then
   print("Reading from RAM with RAMPOS: 0x"..tohex(pos).."/0x"..tohex(#RAM))
  end
  return string.byte(RAM[pos+1])
 elseif type == 1 then
  if debug == true then
   print("Reading from VRAM with RAMPOS: 0x"..tohex(pos).."/0x"..tohex(#GPU.VRAM))
  end
  return string.byte(GPU.VRAM[pos+1])
 end
end

--[[HEX Functions]]--
function tohex(int)
 if int < 0x10 then
  return "0"..string.format('%x', int)
 else
  return string.format('%x', int)
 end
end

function todec(str)
 return tonumber(str,16)
end

--[[GPU Function]]--
function GPUlocate(x,y)
 local i = 0
 for yi=0,y do
  for xi=0,x do
   i = i + 1
  end
 end
 return i
end

function GPUread(x,y,ID)
 local R,G,B = GPU.buffer:newImageData(x, y, SW, SH)
 if ID == 0 then
  return R
 elseif ID == 1 then
  return G
 elseif ID == 2 then
  return B
 end
end

function GPUupdate()
 GPU.screen.R = (GPU.buffer.B)
 GPU.screen.G = (GPU.buffer.G)
 GPU.screen.B = (GPU.buffer.B)
end

--[[this requires to be a function for quick restart access]]--

function start()
 --[[Allowcating RAM and EMU VARS]]--
 SH = 340 --Y
 SW = 480 --X
      --if Running , EMU logs , run in vsync?, show the FPS? ,frames to skip, limit frames to , allocating RAM-POS, allocating VRAM-POS, AutoClose?   , CPS counter , Time For Detection CPS Output , fullscreen  mode?  ,IPScount, Running the BIOS? |
 EMU = {running = 1, logs = "", vsync = Vsync, showFPS = true, frameskip = 0, framelimmit = 60, RAMPOS = {0,0,0,0}, VRAMPOS = {0,0,0,0}, softClose = 1, commands = 0, timesec = love.timer.getTime(), fullscreen =  false, IPS = 0, BIOSrunning = true}
 ROM = {}
 BIOS = {}
 input = {}
 CPU = {REGS = {A = 0, B = 0, C = 0, D = 0, E = 0, F = 0, G = 0, H = 0}, bit = 16, PC = 1, flags = {overflow = 0, halt = 0,}}
 SND = {L = {{type = "Pulse", vol = 0, pitch = 0},{type = "Pulse", vol = 0, pitch = 0},{type = "Noise", vol = 0, pitch = 0},{type = "Sawtooth", vol = 0, pitch = 0}},R = {{type = "Pulse", vol = 0, pitch = 0},{type  = "Pulse", vol = 0, pitch = 0},{type = "Noise", vol = 0, pitch = 0},{type = "Sawtooth", vol = 0, pitch = 0}}}
 GPU = {X = 0, Y = 0, R = 0, G = 0, B = 0, VRAM = "", screen = love.graphics.newCanvas(SW,SH), buffer = love.graphics.newCanvas(SW,SH), CP = {R = {},G = {},B = {}}, update = false}
 RAM = ""
 RAMSLOT = 0
 --GPU = {X = 0, Y = 0, R = 0, G = 0, B = 0, VRAM = "", screen = {R = "",G = "",B = ""}, buffer = {R = "",G = "",B = ""}, H = 340, W = 480, update = false}RAM = ""
 SAV = ""
 MB = {HertzLimmit = 20000000, inputTimer = 400, }
 if Settings.Menu.ShowMenuBar == true then
  love.window.setMode(SW, SH+20, {fullscreen = EMU.fullscreen, msaa = 16, vsync = EMU.vsync})
 else
  love.window.setMode(SW, SH, {fullscreen = EMU.fullscreen, msaa = 16, vsync = EMU.vsync})
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
 
 
 --INIT SYSTEM MEMORY
 --                    BYTE                *KB  *MB
 GPU.VRAM = string.rep(string.char(0), 1024*1024*64)
 RAM      = string.rep(string.char(0), 1024*1024*128)
 
 for i=0,15 do
  table.insert(GPU.CP.R,0x00)
  table.insert(GPU.CP.G,0x00)
  table.insert(GPU.CP.B,0x00)
 end
 
 --printing details--
 print("Listing System Info:")
 print("\\Initializing memory:\n \\"..#GPU.VRAM,"bytes(",#GPU.VRAM/1024/1024,"MB ) VideoRAM Loaded")
 print(" \\"..#RAM,"bytes(",#RAM/1024/1024,"MB ) RAM Loaded\n")
 print("\\Checking Screen:")
 print(" \\H: "..SH..", W: "..SW..", screen: "..((SW*SH)*3).." bytes used("..(((SW*SH)*3)/1024).." KB)\n")
 print("\\Initializing GPU ColorPallet:")
 for i=0, 15 do
  if i < 10 then
   print(" \\0"..i..": "..GPU.CP.R[i+1]..","..GPU.CP.G[i+1]..","..GPU.CP.B[i+1].."|")
  else
   print(" \\"..i..": "..GPU.CP.R[i+1]..","..GPU.CP.G[i+1]..","..GPU.CP.B[i+1].."|")
  end
 end
 local total = ((SW*SH)*3)+#GPU.VRAM+#RAM+(3*15)
 print("\n\\Total memory usage: "..total.." bytes("..(total/1024/1024).." MB)\n")
end

start()
