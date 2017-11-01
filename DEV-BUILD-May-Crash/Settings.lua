--###########################--
--###########################--
--#     THE GAME RAZER      #--
--#    Emulator Settings    #--
--###########################--
--###########################--
--###########################--

--[Menus]--
Settings.Menu.ShowMenuBar   = false             --(Default: false)
Settings.Menu.MenuColor     = {0x64,0x64,0x64}  --RGB Color(Default: {0x64,0x64,0x64})
Settings.Menu.SelectColor   = {0x64,0x64,0xFF}  --RGB Color(Default: {0x64,0x64,0xFF})
Settings.Menu.UseFullWindow = true              --may be unstable (Default: true)

--[Emulation]--


--[Video]--
Settings.Video.Vsync        = false             --(Default: false)
Settings.Video.Fullscreen   = false             --(Default: false)
Settings.Video.Zoom         = 1                 --(Default: 1)
Settings.Video.Filter       = "none"            --none,scanline, 
Settings.Video.SkipFrame    = 0                 --(Default: 0)
Settings.Video.FrameLimmit  = 60                --FPS (Default: 30 or 60)

--[Sound]--
Settings.Sound.Enabled      = false
Settings.Sound.Voices       = {1,2,3,4,5,6,7,8} --(Default: {1,2,3,4,5,6,7,8})

--[Controller0]-- 
 --what input is contoller0?
 --0 = keyboard
 --1 = joypad/joystick0(unstable may crash appon loading)
 --2 = joypad/joystick1(unstable may crash appon loading)
Settings.Controller.takeinput[0] = 0

 --buttons--
 --if your stuck on keynames look in https://love2d.org/wiki/KeyConstant for help
Settings.Controller.A[0]         = "z"
Settings.Controller.B[0]         = "x"
Settings.Controller.C[0]         = "c"

Settings.Controller.X[0]         = "a"
Settings.Controller.Y[0]         = "s"
Settings.Controller.Z[0]         = "d"

Settings.Controller.START[0]     = "return"
Settings.Controller.SELECT[0]    = "backspace"

Settings.Controller.UP[0]        = "up"
Settings.Controller.DOWN[0]      = "down"
Settings.Controller.LEFT[0]      = "left"
Settings.Controller.RIGHT[0]     = "right"

Settings.Controller.L[0]         = "q"
Settings.Controller.R[0]         = "w"

--[Controller1]--
 --what input is contoller1?
 --0 = keyboard
 --1 = joypad/joystick0(unstable may crash appon loading)
 --2 = joypad/joystick1(unstable may crash appon loading)
Settings.Controller.takeinput[1] = 0

 --buttons--
 --if your stuck on keynames look in https://love2d.org/wiki/KeyConstant for help
Settings.Controller.A[1]         = "kp1"
Settings.Controller.B[1]         = "kp5"
Settings.Controller.C[1]         = "kp3"

Settings.Controller.X[1]         = "kp7"
Settings.Controller.Y[1]         = "kp/"
Settings.Controller.Z[1]         = "kp9"

Settings.Controller.START[1]     = "kpenter"
Settings.Controller.SELECT[1]    = "kp+"

Settings.Controller.UP[1]        = "kp8"
Settings.Controller.DOWN[1]      = "kp2"
Settings.Controller.LEFT[1]      = "kp4"
Settings.Controller.RIGHT[1]     = "kp6"

Settings.Controller.L[1]         = "kp0"
Settings.Controller.R[1]         = "kp."

--[[END OF SETTINGS]]--
--so why does discord read my webcam as `UVC Camera (046d:081b)`(logictech 720p webcam) and can see my `Rift Sensor: CV1 Enternal Camer`(OculusRift Sensor)?
