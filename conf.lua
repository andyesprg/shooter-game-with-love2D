-- Configuration
function love.conf(t)
	t.title = "Top game" -- The title of the window the game is in (string)
	t.version = "11.3"         -- The LÖVE version this game was made for (string)
	t.window.width =  1440        -- we want our game to be long and thin.
	t.window.height = 840

	-- For Windows debugging
	t.console = true
end