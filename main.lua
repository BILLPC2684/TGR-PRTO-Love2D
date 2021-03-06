--###########################--
--###########################--
--#      THE GAME RAZER     #--
--#   MAIN STARTUP PROGRAM  #--
--#     **DO NOT EDIT**     #--
--###########################--
--###########################--
--###########################--

--RUN Function--
function love.run()
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
end

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

function love.load(args)
 version = "PRTO v0.74b"
 print("LOADING \""..version.."\"...")
 import = {"init","input","cpu"}
 for i=1,#import do
  require(import[i])
 end
 if #args < 2 then
  error("ROM directory required...")
 else
  ROMFile = io.open(args[2],"r")
  --assert(ROMFile:seek("end"))
  local data = ROMFile:read(("*all"))
  ROMFile:close()
  for i=1,#data do
   table.insert(ROM, string.byte(data[i]))
  end
  local data = ""
  for i=1,#ROM do
   data = data..ROM[i].." "
  end
  data = data.."\n"
  for i=1,#ROM do
   data = data..string.char(ROM[i]).." "
  end
  print(data)
  print("---------------")
 end
 if #args > 2 and args[3] == "--debug" then
  debug = true
 else
  debug = false
 end
 if #args > 2 and args[3] == "--speed" then
  sptest = love.timer.getTime()
  print("[>] Started timer...")
 end
 frame = 0
 FPS = 0
 RF = 0
 MAXIPS = 0
 init_input(0)
 init_input(1)
 
 programhalt = false --for when the program softcloses
end

function love.update(dt)
 if CPU.HALT == true then
  if programhalt == false then
   print("\nEMU: We have detected the main loop has stopped due to a halt...")
   print("This is due to a halt(meaning the program has ended) or the Emulator Error.")
   print("If there is a Emulation Error check above for what the probblem is in the ROM.")
   print("The screen isn't active but is can still be viewed, to reset the emulator you\n need to goto your terminal and press [CTRL] + [C] and relaunch.")
   if sptest then
    print("[||] Stopped, time took to calculate: "..love.timer.getTime()-sptest)
   end
   programhalt = true
  end
 else
  if input.controller0 then
   get_input(0)
  end
  if input.controller1 then
   get_input(1)
  end
  exec()
  if MAXIPS < EMU.IPS then
   MAXIPS = EMU.IPS
   print("Best IPS: "..MAXIPS)
  end
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
	love.graphics.setColor(0xFF,0xFF,0xFF)
    love.graphics.print("FPS: "..RF.."\t| IPS: "..EMU.IPS.."\t| Best IPS: "..MAXIPS,10,SH-15)
	love.graphics.setColor(0,0,0)
    love.graphics.print("FPS: "..RF.."\t| IPS: "..EMU.IPS.."\t| Best IPS: "..MAXIPS,11,SH-14)
	love.graphics.present()
    frame = 0
    FPS = FPS + 1
   else
    frame = frame + 1
   end
  end
 end
end