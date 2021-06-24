-- mdotengine - conf file

function love.conf(t)
	t.window.title = "mdotengine"
	t.window.icon = "lib/sprite/logo.png"
	t.console = true
	t.window.fullscreen = false
	t.window.width = 600
	t.window.height = 600
	t.window.vsync = false
	t.window.resizable = false
	t.modules.joystick = false
	t.modules.physics = false
end