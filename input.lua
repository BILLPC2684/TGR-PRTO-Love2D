--###########################--
--###########################--
--#      THE GAME RAZER     #--
--#    USER INPUT SYSTEM    #--
--#                         #--
--###########################--
--###########################--
--###########################--

--[[INPUTS]]--
--You may edit this to adjust the contolls to your confirts

--[Controller0]--
--what input is contoller0?
--0 = keyboard
--1 = joypad/joystick(0)
--2 = joypad/joystick(1)
input[0]    = 0

--buttons--
--if your stuck on keynames look in https://love2d.org/wiki/KeyConstant for help
A[0]        = "z"
B[0]        = "x"
C[0]        = "c"

X[0]        = "a"
Y[0]        = "s"
Z[0]        = "d"

START[0]    = "enter"
SELECT[0]   = "backspace"

UP[0]       = "up"
DOWN[0]     = "down"
LEFT[0]     = "left"
RIGHT[0]    = "right"

L[0]        = ""
R[0]        = ""

------------------------------------------------------------------------------------------

--[Controller1]--
--what input is contoller1?
--0 = keyboard
--1 = joypad/joystick(0)
--2 = joypad/joystick(1)
input[1]    = 0

--buttons--
--if your stuck on keynames look in https://love2d.org/wiki/KeyConstant for help
A[1]        = "kp1"
B[1]        = "kp5"
C[1]        = "kp3"

X[1]        = "kp7"
Y[1]        = "kp/"
Z[1]        = "kp9"

START[1]    = "kpenter"
SELECT[1]   = "kp+"

UP[1]       = "kp8"
DOWN[1]     = "kp2"
LEFT[1]     = "kp4"
RIGHT[1]    = "kp6"

L[1]        = "kp0"
R[1]        = "kp."

------------------------------------------------------------------------------------------

---[[[**input.lua - DO NOT EDIT**]]]---
joysticks = love.joystick.getJoysticks()

function init_input(controlllerID)
 if input[controlllerID] ~= 0 then
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
end

--Lua num order:	1, 2, 3, 4, 5, 6, 7, 8, 9    , 10    , 12, 13  , 14  , 15
--input string: 	A, B, C, X, Y, Z, L, R, Start, Select, Up, Down, Left, Right
function get_input(controlllerID)
 if controlllerID == 0 then
  for i=0, 0xD do
   input.controller0[i] = false
  end
 elseif controlllerID == 1 then
  for i=0, 0xD do
   input.controller1[i] = false
  end
 end
 if input[controlllerID] == 0 then
  --[[keyboard]]--
  if controlllerID == 0 then
   input.controller0[0x0] = love.keyboard.isDown(A[controlllerID])		--A
   input.controller0[0x1] = love.keyboard.isDown(B[controlllerID])		--B
   input.controller0[0x2] = love.keyboard.isDown(C[controlllerID])		--C
   input.controller0[0x3] = love.keyboard.isDown(X[controlllerID])		--X
   input.controller0[0x4] = love.keyboard.isDown(Y[controlllerID])		--Y
   input.controller0[0x5] = love.keyboard.isDown(Z[controlllerID])		--Z
   input.controller0[0x6] = love.keyboard.isDown(L[controlllerID])		--L
   input.controller0[0x7] = love.keyboard.isDown(R[controlllerID])		--R
   input.controller0[0x8] = love.keyboard.isDown(START[controlllerID])	--Start
   input.controller0[0x9] = love.keyboard.isDown(SELECT[controlllerID])	--Select
   input.controller0[0xA] = love.keyboard.isDown(UP[controlllerID])		--Up
   input.controller0[0xB] = love.keyboard.isDown(DOWN[controlllerID])	--Down
   input.controller0[0xC] = love.keyboard.isDown(LEFT[controlllerID])	--Left
   input.controller0[0xD] = love.keyboard.isDown(RIGHT[controlllerID])	--Right
  elseif controlllerID == 1 then
   input.controller1[0x0] = love.keyboard.isDown(A[controlllerID])		--A
   input.controller1[0x1] = love.keyboard.isDown(B[controlllerID])		--B
   input.controller1[0x2] = love.keyboard.isDown(C[controlllerID])		--C
   input.controller1[0x3] = love.keyboard.isDown(X[controlllerID])		--X
   input.controller1[0x4] = love.keyboard.isDown(Y[controlllerID])		--Y
   input.controller1[0x5] = love.keyboard.isDown(Z[controlllerID])		--Z
   input.controller1[0x6] = love.keyboard.isDown(L[controlllerID])		--L
   input.controller1[0x7] = love.keyboard.isDown(R[controlllerID])		--R
   input.controller1[0x8] = love.keyboard.isDown(START[controlllerID])	--Start
   input.controller1[0x9] = love.keyboard.isDown(SELECT[controlllerID])	--Select
   input.controller1[0xA] = love.keyboard.isDown(UP[controlllerID])		--Up
   input.controller1[0xB] = love.keyboard.isDown(DOWN[controlllerID])	--Down
   input.controller1[0xC] = love.keyboard.isDown(LEFT[controlllerID])	--Left
   input.controller1[0xD] = love.keyboard.isDown(RIGHT[controlllerID])	--Right
  end
 else
  --[[controller]]--
  if controlllerID == 0 then
   input.controller0[0x0] = love.gamepadpressed(joysticks[input[controlllerID]],"a")			-->>															--A
   input.controller0[0x1] = love.gamepadpressed(joysticks[input[controlllerID]],"b")			-->>															--B
   input.controller0[0x2] = joysticks[input[controlllerID]]:getGamepadAxis("triggerleft")		-->>															--C
   input.controller0[0x3] = love.gamepadpressed(joysticks[input[controlllerID]],"x")			-->>															--X
   input.controller0[0x4] = love.gamepadpressed(joysticks[input[controlllerID]],"y")			-->>															--Y
   input.controller0[0x5] = joysticks[input[controlllerID]]:getGamepadAxis("triggerleft")		-->>															--Z
   input.controller0[0x6] = love.gamepadpressed(joysticks[input[controlllerID]],"leftsholder")	-->>															--L
   input.controller0[0x7] = love.gamepadpressed(joysticks[input[controlllerID]],"rightsholder")	-->>															--R
   input.controller0[0x8] = love.gamepadpressed(joysticks[input[controlllerID]],"start")		-->>															--Start
   input.controller0[0x9] = love.gamepadpressed(joysticks[input[controlllerID]],"back") 		-->>															--Select
   input.controller0[0xA] = love.gamepadpressed(joysticks[input[controlllerID]],"dpup")    or (joysticks[input[controlllerID]]:getGamepadAxis("lefty") < 0.5)	--Up
   input.controller0[0xB] = love.gamepadpressed(joysticks[input[controlllerID]],"dpdown")  or (joysticks[input[controlllerID]]:getGamepadAxis("lefty") > 0.5)	--Down
   input.controller0[0xC] = love.gamepadpressed(joysticks[input[controlllerID]],"dpleft")  or (joysticks[input[controlllerID]]:getGamepadAxis("leftx") < 0.5)	--Left
   input.controller0[0xD] = love.gamepadpressed(joysticks[input[controlllerID]],"dpright") or (joysticks[input[controlllerID]]:getGamepadAxis("leftx") > 0.5)	--Right
  elseif controlllerID == 1 then
   input.controller1[0x0] = love.gamepadpressed(joysticks[input[controlllerID]],"a")			-->>															--A
   input.controller1[0x1] = love.gamepadpressed(joysticks[input[controlllerID]],"b")			-->>															--B
   input.controller1[0x2] = joysticks[input[controlllerID]]:getGamepadAxis("triggerleft")		-->>															--C
   input.controller1[0x3] = love.gamepadpressed(joysticks[input[controlllerID]],"x")			-->>															--X
   input.controller1[0x4] = love.gamepadpressed(joysticks[input[controlllerID]],"y")			-->>															--Y
   input.controller1[0x5] = joysticks[input[controlllerID]]:getGamepadAxis("triggerleft")		-->>															--Z
   input.controller1[0x6] = love.gamepadpressed(joysticks[input[controlllerID]],"leftsholder")	-->>															--L
   input.controller1[0x7] = love.gamepadpressed(joysticks[input[controlllerID]],"rightsholder")	-->>															--R
   input.controller1[0x8] = love.gamepadpressed(joysticks[input[controlllerID]],"start")		-->>															--Start
   input.controller1[0x9] = love.gamepadpressed(joysticks[input[controlllerID]],"back") 		-->>															--Select
   input.controller1[0xA] = love.gamepadpressed(joysticks[input[controlllerID]],"dpup")    or (joysticks[input[controlllerID]]:getGamepadAxis("lefty") < 0.5)	--Up
   input.controller1[0xB] = love.gamepadpressed(joysticks[input[controlllerID]],"dpdown")  or (joysticks[input[controlllerID]]:getGamepadAxis("lefty") > 0.5)	--Down
   input.controller1[0xC] = love.gamepadpressed(joysticks[input[controlllerID]],"dpleft")  or (joysticks[input[controlllerID]]:getGamepadAxis("leftx") < 0.5)	--Left
   input.controller1[0xD] = love.gamepadpressed(joysticks[input[controlllerID]],"dpright") or (joysticks[input[controlllerID]]:getGamepadAxis("leftx") > 0.5)	--Right
  end  
 end
end