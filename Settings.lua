-- mdotengine - settings file

-- global Love2D framework functions
Filesystem = love.filesystem
Keyboard   = love.keyboard
Graphics   = love.graphics
Window     = love.window
Event      = love.event
Mouse      = love.mouse
Timer      = love.timer

-- math functions
Random = math.random
Floor  = math.floor
Ceil   = math.ceil
Atg2   = math.atan2
Sqrt   = math.sqrt
Cos    = math.cos
Sin    = math.sin
Pow    = math.pow
Max    = math.max
Min    = math.min
Rad    = math.rad
Exp    = math.exp
Log    = math.log
Pi     = math.pi

-- init settings
math.randomseed(os.time())
Mouse.setVisible(false)
Graphics.setDefaultFilter("nearest", "nearest")

-- keybindings
bindings = {
	exit  = "escape",
	debug = "tab",
	cam = {
		left      = "a",
		right     = "d",
		up        = "w",
		down      = "s",
		stop      = "x",
		rotateCW  = "e",
		rotateCCW = "q",
		frame     = "j",
		test      = "t",
		debug     = "tab"
	}
}