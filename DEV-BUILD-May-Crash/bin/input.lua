--###########################--
--###########################--
--#      THE GAME RAZER     #--
--#    USER INPUT SYSTEM    #--
--#     **DO NOT EDIT**     #--
--###########################--
--###########################--
--###########################--

      love.graphics.draw(GPU.buffer, 0, 0)
joysticks = love.joystick.getJoysticks()

function init_input(controlllerID)
 if Settings.Controller.takeinput[controlllerID] ~= 0 then
  if debug == true then
   print("init: "..joysticks[input[controlllerID]])
  end
 end
 if controlllerID == 0 then
  input.controller0 = {}
  for i=0, 0xD do
   input.controller0[i] = false
  end
 elseif controlllerID == 1 then
  input.controller1 = {}
  for i=0, 0xD do
   input.controller1[i] = false
  end
 end
 if input[controlllerID] ~= 0 then
  
 else
  
 end
 
 --love.joystick.setGamepadMapping(joysticks[Settings.Controller.takeinput[controlllerID]]:getGUID(),"a", button, 0)
 --print(joysticks[Settings.Controller.takeinput[controlllerID]]:getGUID())
end

--Lua num order:	1, 2, 3, 4, 5, 6, 7, 8, 9    , 10    , 11, 12  , 13  , 14
--input string: 	A, B, C, X, Y, Z, L, R, Start, Select, Up, Down, Left, Right
function get_input(controlllerID)
 --for i=1,100 do
 -- print(joysticks[Settings.Controller.takeinput[controlllerID]][i])
 --end
 if controlllerID == 0 then
  for i=0, 0xD do
   input.controller0[i] = false
  end
 elseif controlllerID == 1 then
  for i=0, 0xD do
   input.controller1[i] = false
  end
 end
 if Settings.Controller.takeinput[controlllerID] == 0 then
  --[[keyboard]]--
  local uinput = {
   love.keyboard.isDown(Settings.Controller.A[controlllerID]),        --A
   love.keyboard.isDown(Settings.Controller.B[controlllerID]),        --B
   love.keyboard.isDown(Settings.Controller.C[controlllerID]),        --C
   love.keyboard.isDown(Settings.Controller.X[controlllerID]),        --X
   love.keyboard.isDown(Settings.Controller.Y[controlllerID]),        --Y
   love.keyboard.isDown(Settings.Controller.Z[controlllerID]),        --Z
   love.keyboard.isDown(Settings.Controller.L[controlllerID]),        --L
   love.keyboard.isDown(Settings.Controller.R[controlllerID]),        --R
   love.keyboard.isDown(Settings.Controller.START[controlllerID]),    --Start
   love.keyboard.isDown(Settings.Controller.SELECT[controlllerID]),   --Select
   love.keyboard.isDown(Settings.Controller.UP[controlllerID]),       --Up
   love.keyboard.isDown(Settings.Controller.DOWN[controlllerID]),     --Down
   love.keyboard.isDown(Settings.Controller.LEFT[controlllerID]),     --Left
   love.keyboard.isDown(Settings.Controller.RIGHT[controlllerID]),    --Right
  }
  if controlllerID == 0 then
   input.controller0 = uinput
  elseif controlllerID == 1 then
   input.controller1 = uinput
  end
 else
  --[[controller]]--
  local uinput = {
   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("a"),			--A
   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("b"),			--B
   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("x"),			--C
   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("dpleft"),		--X
   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("dpdown"),		--Y
   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("dpright"),	--Z
   (joysticks[Settings.Controller.takeinput[controlllerID]]:getAxis(3) > 0),			--L
   (joysticks[Settings.Controller.takeinput[controlllerID]]:getAxis(6) > 0),			--R
   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("start"),		--Start
   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("rightstick"),	--Select
--   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("dpup") or
    (joysticks[Settings.Controller.takeinput[controlllerID]]:getAxis(2) < -0.5),		--Up
--   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("dpdown") or
    (joysticks[Settings.Controller.takeinput[controlllerID]]:getAxis(2) > 0.5),			--Down
--   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("dpleft") or
    (joysticks[Settings.Controller.takeinput[controlllerID]]:getAxis(1) < -0.5),		--Left
--   joysticks[Settings.Controller.takeinput[controlllerID]]:isGamepadDown("dpright") or
    (joysticks[Settings.Controller.takeinput[controlllerID]]:getAxis(1) > 0.5),			--Right
  }
  if controlllerID == 0 then
   input.controller0 = uinput
  elseif controlllerID == 1 then
   input.controller1 = uinput
  end
 end  
end
