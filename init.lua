--###########################--
--###########################--
--#      THE GAME RAZER     #--
--#    INIT STARTUP FILE    #--
--#     **DO NOT EDIT**     #--
--###########################--
--###########################--
--###########################--


--ffi = require('ffi')
--RAM Functions--
function WRAM(pos, int, type)
 if type == 0 then
  RAM = table.concat{RAM:sub(1,pos), string.char(int), RAM:sub(pos+2)}
 elseif type == 1 then
  GPU.VRAM = table.concat{GPU.VRAM:sub(1,pos), string.char(int), GPU.VRAM:sub(pos+2)}
 end
end
function RRAM(pos, type)
 if type == 0 then
  return string.byte(RAM[pos+1])
 elseif type == 1 then
  return string.byte(GPU.VRAM[pos+1])
 end
end

--HEX Functions--
function tohex(int)
 if int < 0x10 or (int < 0x10 and int < 0x10) then
  return "0"..string.format('%x', int)
 else
  return string.format('%x', int)
 end
end
function todec(str)
 return tonumber(str,16)
end

--GPU Function--
function GPUlocate(x,y)
 local i = 0
 for yi=0,y do
  for xi=0,x do
   i = i + 1
  end
 end
 return i
 --return ((y%GPU.H)*GPU.W)+(x%GPU.W)
end

--[[function GPUplot(x,y,R,G,B)
 print(x,y,R,G,B)
 GPU.buffer.R = table.concat{GPU.buffer.R:sub(1,GPUlocate(x,y)), string.char(R), GPU.buffer.R:sub(GPUlocate(x,y)+2)}
 GPU.buffer.G = table.concat{GPU.buffer.G:sub(1,GPUlocate(x,y)), string.char(G), GPU.buffer.G:sub(GPUlocate(x,y)+2)}
 GPU.buffer.B = table.concat{GPU.buffer.B:sub(1,GPUlocate(x,y)), string.char(B), GPU.buffer.B:sub(GPUlocate(x,y)+2)}
end]]--

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
 --[[for i=0,#GPU.buffer.R do
  GPU.screen.R = table.concat{GPU.screen.R:sub(1,i), GPU.buffer.R[i], GPU.screen.R:sub(i+2)}
  GPU.screen.G = table.concat{GPU.screen.G:sub(1,i), GPU.buffer.G[i], GPU.screen.G:sub(i+2)}
  GPU.screen.B = table.concat{GPU.screen.B:sub(1,i), GPU.buffer.B[i], GPU.screen.B:sub(i+2)}
 end]]
 print(0)
 GPU.screen.R = (GPU.buffer.B)
 print(1)
 GPU.screen.G = (GPU.buffer.G)
 print(2)
 GPU.screen.B = (GPU.buffer.B)
 print(3)
 
end

--Allowcating RAM and EMU VARS--
     --if Running , EMU logs , allocating RAMPOS , AutoClose?   , frames to skip, CPS counter , Time For Detection CPS Output , fullscreen mode?  , counter, 
SH = 340 --Y
SW = 480 --X
EMU = {running = 1, logs = "", vsync = 0, frameskip = 120, framelimmit = 60, RAMPOS = {0,0,0,0}, softClose = 1, commands = 0, timesec = love.timer.getTime(), fullscreen = false, IPS = 0, }
ROM = {}
BIOS = {}
CPU = {REGS = {A = 0, B = 0, C = 0, D = 0, E = 0, F = 0, G = 0, H = 0}, bit = 16, PC = 1}
SND = {L = {{type = "Pulse", vol = 0, pitch = 0},{type = "Pulse", vol = 0, pitch = 0},{type = "Noise", vol = 0, pitch = 0},{type = "Sawtooth", vol = 0, pitch = 0}},R = {{type = "Pulse", vol = 0, pitch = 0},{type = "Pulse", vol = 0, pitch = 0},{type = "Noise", vol = 0, pitch = 0},{type = "Sawtooth", vol = 0, pitch = 0}}}
GPU = {X = 0, Y = 0, R = 0, G = 0, B = 0, VRAM = "", screen = love.graphics.newCanvas(SW,SH), buffer = love.graphics.newCanvas(SW,SH), update = false}
RAM = ""
--GPU = {X = 0, Y = 0, R = 0, G = 0, B = 0, VRAM = "", screen = {R = "",G = "",B = ""}, buffer = {R = "",G = "",B = ""}, H = 340, W = 480, update = false}RAM = ""
SAV = ""
MB = {HertzLimmit = 20000000, inputTimer = 400, }
input,A,B,C,X,Y,Z,L,R,START,SELECT,UP,DOWN,LEFT,RIGHT = {},{},{},{},{},{},{},{},{},{},{},{},{},{},{}

love.window.setMode(SW, SH, {fullscreen = EMU.fullscreen, msaa = 16, vsync = EMU.vsync})

--[[
GPU.screen.R = string.rep(string.char(0), GPU.H*GPU.W)
GPU.screen.G = string.rep(string.char(0), GPU.H*GPU.W)
GPU.screen.B = string.rep(string.char(0), GPU.H*GPU.W)

GPU.buffer.R = string.rep(string.char(0), GPU.H*GPU.W)
GPU.buffer.G = string.rep(string.char(0), GPU.H*GPU.W)
GPU.buffer.B = string.rep(string.char(0), GPU.H*GPU.W)
]]--

--                    BYTE                *KB  *MB
GPU.VRAM = string.rep(string.char(0), 1024*1024*64)

--               BYTE                *KB  *MB
RAM = string.rep(string.char(0), 1024*1024*128)

--printing details--
print(#GPU.VRAM*8,"bytes(",#GPU.VRAM/1024/1024,"MB ) VideoRAM Loaded")
print(#RAM*8,"bytes(",#RAM/1024/1024,"MB ) RAM Loaded")
--print(GPU.H.."x"..GPU.W.." screeen: "..#GPU.screen.R+#GPU.screen.G+#GPU.screen.B.." bytes used("..((#GPU.screen.R+#GPU.screen.G+#GPU.screen.B)/1024).." KB)")
--print("Total memory usage: "..((#RAM+#GPU.VRAM+#GPU.screen.R+#GPU.screen.G+#GPU.screen.B)/1024/1024).."MB")

--commited out RAM testing--

--WRAM(0, 0x4B, 0)
--print(RAM)
--print(0x4B,RRAM(0, 0))