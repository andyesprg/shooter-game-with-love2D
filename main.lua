--menu
local game_state = 'menu'
local menus = { 'Play', 'Screen', 'Exit' }
local selected_menu_item = 1


--Tontería menú título
enemymenu = { x = -80, y = love.graphics:getHeight()/5 + 10, speed = 200}
bulletmenu = { x = -80, y = love.graphics:getHeight()/5 + 50, speed = 100}
collision = false
mataalien = false
explo = 0
explo2 = 0


--Para explosiones pequeñas
explosions = {}
nFrames = 17
image = love.graphics.newImage ('assets/explosion.png') -- image 1088x64, 17 frames 64x64 in one line
frames = {}
for i = 1, nFrames do -- https://sheepolution.com/learn/book/17
	local x = 64*(i-1)
	local quad = love.graphics.newQuad(x, 0, 64, 64, image:getDimensions())		
	table.insert (frames, quad)
end

--Para explosión grande
explosions2 = {}
nFrames2 = 17
image = love.graphics.newImage ('assets/explosion2.png') -- image 1088x64, 17 frames 64x64 in one line
frames2 = {}
for i = 1, nFrames2 do -- https://sheepolution.com/learn/book/17
	local x = 200*(i-1)
	local quad = love.graphics.newQuad(x, 0, 200, 200, image:getDimensions())		
	table.insert (frames2, quad)
end
	
	
-- Timers
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax
createEnemyTimerMax = 0.3
createEnemyTimer = createEnemyTimerMax
createalienTimerMax = 0.9
createalienTimer = createalienTimerMax
createheartTimerMax = 14
createheartTimer = createheartTimerMax
createjokerTimerMax = 0.1
createjokerTimer = createjokerTimerMax
createbombaTimerMax = 4
createbombaTimer = createbombaTimerMax
createbomba2TimerMax = 2
createbomba2Timer = createbomba2TimerMax


-- Entity Storage
local bullets = {} 
local enemies = {}
local bombas ={} 
local aliens = {}
local vidas = {}
local joker = {}
local heartmal = {}
local soldiparachute = {}
isAlive = true
score = 0
balas = 0
enemigos = 0
local corazones = 3
comodin = 1
bomb = false
soldado = 0

--Para que se puedan modificar la localización de los objetos dependiendo del tamaño de la pantalla
local ventana = false

--crea array estrellas y en load se crean estrellas una a una
local stars = {}

-- Player Object
player = { x = love.graphics:getWidth()/2, y = 1870, speed = 250, img = nil }

--Título
local text = {}
text.words = "Maverick" 
if ventana == false then
text.x = love.graphics:getWidth()/2.2 - 10              
text.y = love.graphics:getHeight()/5 + 30  
else
text.x = love.graphics:getWidth()/2 - 10              
text.y = love.graphics:getHeight()/5 + 30 
end
local font = love.graphics.setNewFont("assets/heavy_data.ttf", 40)
--alien menu
local alienmenu = { x = 0, y = 350, speed = 220, img = alienImg }


--      --
-- load --
--      --
function love.load()
--Para el fondo de estrellas
	for i = 1, 500  do
		aleatorio = math.random(1,3)
		if aleatorio == 1 then
			velocidad = 120
			colores = {0.5+0.5*love.math.random()^0.5, 0.5+0.5*love.math.random()^0.5, 0.5+0.5*love.math.random()^0.5}
		elseif aleatorio == 2 then
			velocidad = 190
			colores = {0.5+0.5*love.math.random()^0.5, 0.5+0.5*love.math.random()^0.5, 0.5+0.5*love.math.random()^0.5}
		else
			velocidad = 230
			colores = {0.5+0.5*love.math.random()^0.5, 0.5+0.5*love.math.random()^0.5, 0.5+0.5*love.math.random()^0.5}
		end
		--se crea características de las estrellas
		star = {}
		star.x = math.random()*1920
		star.y = math.random()*1080
		star.vy = velocidad
		star.vx = 0
		star.color = colores
		table.insert(stars, star)	
	end
	
	--Para la propulsión del enemigo con un emisor de partículas
	local img = love.graphics.newImage('logo.png')
	psystem = love.graphics.newParticleSystem(img, 100)
	psystem:setParticleLifetime(1, 2)
	psystem:setEmissionRate(50)
	psystem:setSizeVariation(1)
	psystem:setLinearAcceleration(-700, -100, 40, 40) 
	psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) 
	--
	local img = love.graphics.newImage('logo.png')
	system = love.graphics.newParticleSystem(img, 100)
	system:setParticleLifetime(0, 0.7)
	system:setEmissionRate(50)
	system:setSizeVariation(1)
	system:setLinearAcceleration(-100, -500, 100, 40) 
	system:setColors(1, 1, 1, 1, 1, 1, 1, 0) 

	--Imágenes
	player.img = love.graphics.newImage('assets/plane.png')
	enemyImg = love.graphics.newImage('assets/enemy.png')
	alienImg = love.graphics.newImage('assets/alien.png')
	bulletImg = love.graphics.newImage('assets/bullet.png')
	bulletImg2 = love.graphics.newImage('assets/laserGreen13.png')
	bulletImg3 = love.graphics.newImage('assets/laserRed07.png')
	bulletImg4 = love.graphics.newImage('assets/laserGreen15.png')
	bulletImg5 = love.graphics.newImage('assets/laserBlue09.png')
	bulletImg6 = love.graphics.newImage('assets/laserRed08.png')
	vidasImg = love.graphics.newImage('assets/heart.png')
	heartmalImg = love.graphics.newImage('assets/heartmal.png')
	joker1Img = love.graphics.newImage('assets/azul.png')
	joker2Img = love.graphics.newImage('assets/verde.png')
	joker3Img = love.graphics.newImage('assets/rojo.png')
	joker4Img = love.graphics.newImage('assets/rosa.png')
	joker5Img = love.graphics.newImage('assets/amarillo.png')
	joker6Img = love.graphics.newImage('assets/todo.png')
	bombaImg = love.graphics.newImage ("assets/bomba.png")
	gunSound = love.audio.newSource("assets/laser.wav", "static")
	soundtrack = love.audio.newSource("assets/Venus.wav", "static")
	pierde = love.audio.newSource("assets/pierde.wav", "stream")
	atrapaestrella = love.audio.newSource("assets/estrella.wav", "static")
	atrapavida = love.audio.newSource("assets/vida.wav", "static")
	explota = love.audio.newSource("assets/explota.wav", "static")
	choque = love.audio.newSource("assets/choque.wav", "static")
	vidaImg = love.graphics.newImage('assets/vida.png') 
	aliadoImg = love.graphics.newImage('assets/aliado.png') 
	aliado2Img = love.graphics.newImage('assets/aliado.png') 
	spockImg = love.graphics.newImage('assets/spock.png') 
	fraseImg = love.graphics.newImage("assets/frase.png")
	parachuteImg = love.graphics.newImage("assets/soldier.png")
	enemymenuImg = love.graphics.newImage('assets/enemymenu.png')
	bulletmenuImg = love.graphics.newImage('assets/bulletmenu.png')  

	--Carga spock y su frase
	spock = {x = love.graphics:getWidth()/1.1, y = love.graphics:getHeight()/1.25, speed = 220, img = spockImg}
	frase = {x = love.graphics:getWidth()/1.2 - 30, y = love.graphics:getHeight()/1.25 + 30, speed = 220, img = fraseImg}
end


--        --
-- update --
--        --
function love.update(dt)
	--Emisor de estrellas
	psystem:update(dt)
	--CREACIÓN ANIMACIÓN SEL TÍTULO
	bulletmenu.x = bulletmenu.x + 300 * dt
	collisionsbulletmenu(dt)
	collisionalienmenu()
	positiontitulo(dt)

	-- Para que el avión no se vaya de la pantalla
	if ventana == false then
		positionplayer(dt)
	else
		positionplayerpeque(dt)
	end

	--Para que al poner pantalla en grande se pone spock en su posición
	--con pantalla pequeña
	if ventana == false then
		spock.y = love.graphics:getHeight()/1.25
		frase.y = love.graphics:getHeight()/1.25 + 30
		--Para Spock y su frase, que se mueva
		if love.keyboard.isDown('s') and love.keyboard.isDown('p') and love.keyboard.isDown('o') and love.keyboard.isDown('c') and love.keyboard.isDown('k') then
			positionspock(dt)
			positionfrase(dt)
		else 
			positionspockback(dt)
			positionfraseback(dt)		
		end
	--con pantalla grande
	else
		spock.y = love.graphics:getHeight()/1.25
		frase.y = love.graphics:getHeight()/1.25 + 30
		--Para Spock y su frase, que se mueva
		if love.keyboard.isDown('s') and love.keyboard.isDown('p') and love.keyboard.isDown('o') and love.keyboard.isDown('c') and love.keyboard.isDown('k') then
			positionspock(dt)
			positionfrase(dt)
		else 
			positionspockback(dt)
			positionfraseback(dt)		
		end
	end
	
	--Valores para posición del Título
	window_width, window_height = love.graphics.getDimensions()
	font_height = font:getHeight() + 60

	--Para que se haga update juego
	if game_state == 'game' then
      	game_update(dt)
	end
	
	--Para que el alien se mueva--
	positionalienmenu(dt)
	
	-- Para el fondo de pantalla, update estrellas
	for i, star in ipairs (stars) do
		star.y = star.y + (star.vy * dt)
		if star.y > 1080 then
			star.x = math.random()*1920
			star.y = math.random()*-10
		end	
	end
end


--      --
-- draw --
--      --
function love.draw()
	if game_state == 'menu' then
		--Emisor de partículas
		love.graphics.draw(psystem, enemymenu.x - 5, enemymenu.y + 44)
		
		draw_menu()
		pierde:play()
	elseif game_state == 'how-to-play' then
		draw_how_to_play()
		pierde:play()
	else -- game_state == 'game'
		if isAlive then
			soundtrack:play()
			pierde:stop()
			explo2 = 71
			explo = 5	
		else
			pierde:play()
			soundtrack:stop()
		end
	draw_game2()
	end
end
 
 
 -- dibuja menu
function draw_menu()
	--valores para las letras del menú
	local horizontal_center = window_width / 2
	local vertical_center = window_height / 1.8
	local start_y = vertical_center - (font_height * (#menus / 2))
	
	-- draw game title
	--boolean para que desaprezcan los siguientes objetos cuando esté a true
	if collision == false then
		love.graphics.draw(bulletmenuImg, bulletmenu.x, bulletmenu.y)
	end
	if mataalien == false then
		love.graphics.draw(alienImg, alienmenu.x, alienmenu.y)
	end
	
	love.graphics.draw(enemymenuImg, enemymenu.x, enemymenu.y)
	love.graphics.push()
	love.graphics.setColor(0, 1, 1, 1)
	love.graphics.pop()  
	love.graphics.print(text.words, text.x, text.y)
	
	-- draw menu items
	for i = 1, #menus do
		--Cargar fondo en el menú
		for i, star in ipairs (stars) do
			love.graphics.push()
			love.graphics.setColor(star.color)
			love.graphics.rectangle( "fill", star.x, star.y, 2, 3)
			love.graphics.pop()
		end
		--Se hace el color al seleccionar
		if i == selected_menu_item then
			love.graphics.push()	
			love.graphics.setColor(1, 0, 1, 1)
			love.graphics.pop()
		else
			love.graphics.push()
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.pop()

			--Spock se dibuja aquí para que no se pinte rosa
			love.graphics.draw(spock.img, spock.x, spock.y)
			if love.keyboard.isDown('s') and love.keyboard.isDown('p') and love.keyboard.isDown('o') and love.keyboard.isDown('c') and love.keyboard.isDown('k') then
				love.graphics.draw(frase.img, frase.x, frase.y)
			end
		end
	--centralizar letras del menú
	love.graphics.printf(menus[i], love.graphics:getWidth()/2.2 - 10, start_y + font_height * (i-1), 180, "center")
	end

	--Para las explosiones que se van a hacer en el título
	for i, explosion in ipairs (explosions) do
		local image = explosion.image
		local x, y, r = explosion.x, explosion.y, explosion.r
		local currentFrame = math.floor((love.timer.getTime( ) - explosion.time)/explosion.tFrame)+1
		if frames[currentFrame] then
			love.graphics.draw(explosion.image, frames[currentFrame], x, y, r, 1, 1, 32, 32)
		else
			explosion.valid = false
		end
	end
end


--Funciones del menú
--colisiones
function CheckCollisionmenu(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
        x2 < x1+w1 and
        y1 < y2+h2 and
        y2 < y1+h1
end

function collisionsbulletmenu(dt)
	if CheckCollisionmenu(text.x, text.y, 32, 200, bulletmenu.x, bulletmenu.y, 26, 10) then
		text.x = text.x + 350 * dt
		enemymenu.x = enemymenu.x + 450 * dt
		collision = true
		if explo2 < 70 then 
			newExplosion11(text.x, text.y)
			explo2 = explo2 + 1
		end
	end
end

function collisionalienmenu()
	if CheckCollisionmenu(text.x, text.y, 32, 200, alienmenu.x, alienmenu.y, 100, 50) then
		mataalien = true
		if explo < 4 then 
			newExplosion11(alienmenu.x, alienmenu.y)
			explo = explo + 1
		end
	end
end


--Movimiento explosion
function newExplosion11(x, y)
	explosion = {}
	explosion.valid = true
	aleatorio = math.random (20, 90)
	aleatorio2 = math.random (20, 50)
	explosion.x = x + aleatorio
	explosion.y = y + aleatorio2
	r = math.pi/2 * math.random (0, 3)
	explosion.image = image
	explosion.time = love.timer.getTime( )
	explosion.tFrame = 1/30
	table.insert (explosions, explosion)
	explota:play()
end


--Movimiento Título
function  positiontitulo(dt)
	if text.x > 1200 then
		text.y = text.y + 155 * dt
		enemymenu.x = enemymenu.x + 450 * dt
	end
	if text.y > 200 then
		text.x = text.x - 130 * dt
		enemymenu.x = enemymenu.x + 450 * dt
	end
	if text.x < 250 then
		text.y = text.y - 140 * dt
	end
	if text.y < 145 then
		text.x = text.x + 160 * dt
	end
end


--Movimiento personajes por el menu
--spock
function positionspock(dt)
	spock.x = spock.x + (180 * dt)
	if spock.x > 1800 then 
		spock.x = 1920
	end
end

--frase
function positionfrase(dt)
	frase.x = frase.x + (180 * dt)
	if frase.x > 1780 then 
		frase.x = 1920
	end
end

--alien
function positionalienmenu(dt)
	if alienmenu.y == 350 then
		alienmenu.x = alienmenu.x + (180 * dt)
	end
	if alienmenu.x > 400 then
		alienmenu.y = alienmenu.y - (180 * dt)
	end
	if alienmenu.y < 51 then
		alienmenu.x = alienmenu.x - (180 * dt)
	end
	if alienmenu.x < 90  and alienmenu.y < 348 then
		alienmenu.y = alienmenu.y + (180 * dt)
		if alienmenu.y > 348 then
			alienmenu.y = 350
		end
	end			
end

--posición de vuelta spock
function positionspockback(dt)
	if spock.x == love.graphics:getWidth()/1.2 then 
		spock.x = love.graphics:getWidth()/1.2
	elseif spock.x >  love.graphics:getWidth()/1.2 then
		spock.x = spock.x - (180 * dt)
	end
end

--posición de vuelta frase
function positionfraseback(dt)
	if frase.x == love.graphics:getWidth()/1.2 - 30 then 
		frase.x = love.graphics:getWidth()/1.2 - 30
	elseif frase.x >  love.graphics:getWidth()/1.2 - 30 then
		frase.x = frase.x - (180 * dt)
	end
end


--Para poner la pantalla en grande
function draw_how_to_play()
	if (love.window.getFullscreen()) then
		love.window.setFullscreen(false, 'desktop')
		ventana = false
	else 
	   love.window.setFullscreen(true, 'desktop')
	   ventana = true
	end
	game_state = 'menu'
end


--Qué hace cada tecla
function love.keypressed(key, scan_code, is_repeat)
	if game_state == 'menu' then
		menu_keypressed(key)
	elseif game_state == 'how-to-play' then
		how_to_play_keypressed(key)
	else -- game_state == 'game'
		game_keypressed(key)
	end
end

function menu_keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'up' then
		selected_menu_item = selected_menu_item - 1
		if selected_menu_item < 1 then
			selected_menu_item = #menus
		end
	elseif key == 'down' then
		selected_menu_item = selected_menu_item + 1
		if selected_menu_item > #menus then
			selected_menu_item = 1
		end
	elseif key == 'return' or key == 'kpenter' then
		if menus[selected_menu_item] == 'Play' then
			game_state = 'game'
		elseif menus[selected_menu_item] == 'Screen' then
			game_state = 'how-to-play'
		elseif menus[selected_menu_item] == 'Exit' then
			love.event.quit()
		end
	end
end

function how_to_play_keypressed(key)
	if key == 'escape' then
		game_state = 'menu'
	end
end

function game_keypressed(key)
	if key == 'escape' then
		game_state = 'menu'
	end
end


--                --
--                --
-- The game start --
--                --
--                --


--Posición jugador por pantalla, para que no se salga del campo de visión
function positionplayer(dt)
	if player.y < 0 then 
		player.y = 0
	elseif player.x < 0 then 
		player.x = 0
	elseif player.y > 760 then 
		player.y = 760
	elseif player.x > 1360 then 
		player.x = 1360
	end
end

function positionplayerpeque(dt)
	if player.y < 0 then 
		player.y = 0
	elseif player.x < 0 then 
		player.x = 0
	elseif player.y > 1000 then 
		player.y = 1000
	elseif player.x > 1840	then 
		player.x = 1840
	end
end


--cálculo canTimershoot
 function canTimershoot(dt)
	 if isAlive then
	canShootTimer = canShootTimer - (1 * dt)
		if canShootTimer < 0 then
			canShoot = true
		end
	end
end


--create enemigos y sus posiciones
--enemy
function createTimerEnemy(dt)
		createEnemyTimer = createEnemyTimer - (1 * dt)
		if createEnemyTimer < 0 then
			createEnemyTimer = createEnemyTimerMax
			randomNumber = math.random(10, love.graphics.getWidth() - 10)
			newEnemy = { x = randomNumber, y = -80, img = enemyImg }
			table.insert(enemies, newEnemy)
			enemigos = enemigos + 1
		end
end

function positionenemy(dt)
	for i, enemy in ipairs(enemies) do
		enemy.y = enemy.y + (250 * dt)
		if enemy.y > 1100 then 
			table.remove(enemies, i)          -- si se quita essto los enemigos salen mal
		end
	end
end

--alien
function createTimeralien(dt)
		createalienTimer = createalienTimer - (1 * dt)
		if createalienTimer < 0 then
			createalienTimer = createalienTimerMax
			randomNumber = math.random(10, love.graphics.getWidth() - 10)
			newalien = { x = randomNumber, y = -10, img = alienImg }
			table.insert(aliens, newalien)
		end
end

function moveToPlayer(dt)
	for i, alien in ipairs(aliens) do
	  if (alien.x - player.x) > 10 then
		alien.y = alien.y + 240 * dt
		alien.x = alien.x - 170 * dt
	  elseif (alien.x - player.x) < -10 then
		alien.y = alien.y + 240 * dt
		alien.x = alien.x + 170 * dt
	  else
		alien.y = alien.y + (170 * dt)
	  end
		if alien.y > 1100 then 
			table.remove(aliens, i)
		end
	end
end

--heartmal
function heartmalcreate(dt, x, y)
	if isAlive then
		malheart = {}
		malheart.x = x
		malheart.y = y
		malheart.img = heartmalImg
		table.insert(heartmal, malheart)
	end
end

function positionheartmal(dt)
	for i, malheart in ipairs(heartmal) do
		malheart.y = malheart.y + (280 * dt)
		if malheart.y > 1100 then 
			table.remove(heartmal, i)
		end
	end
end


--create comodines, vidas, balas, bombas y sus resoectivas posiciones
--bombas
function createTimerbomba(dt)
	if isAlive then
	createbombaTimer = createbombaTimer - (1  * dt)
		if createbombaTimer < 0 then
			if love.keyboard.isDown('space') then
				newbomba = { x = player.x, y = player.y, img = bombaImg }
				table.insert(bombas, newbomba)
				bomb = true
				createbombaTimer = createbombaTimerMax
			end
		end
	end
end

function createTimerba(dt)
	createbomba2Timer = createbomba2Timer - (1  * dt)
	if createbomba2Timer < 0 then
		for i, newbomba in ipairs(bombas) do
			explosion1(newbomba.x, newbomba.y)  
			bomb = false
			createbomba2Timer = createbomba2TimerMax
		end
	end
end

function positionbomba(dt)
	for i, bomba in ipairs(bombas) do
		bomba.y = bomba.y - (240 * dt)        -- si se quita essto los enemigos salen mal
	end
end

--explosión de la bomba
function explosion1(x, y)
	table.remove(bombas, i) 
	explosion2 = {}
	explosion2.valid = true
	explosion2.x = x - 50
	explosion2.y = y - 50
	r = math.pi/2 * math.random (0, 3)
	explosion2.image = image
	explosion2.time = love.timer.getTime( )
	explosion2.tFrame = 1/30
	table.insert (explosions2, explosion2)
	explota:play()
end

--jokers
function createTimerjoker1(dt, x, y)
	createjokerTimer = createjokerTimer - (1 * dt)
	if createjokerTimer < 0 then
		createjokerTimer = createjokerTimerMax
		joke = {}
		joke.x = x
		joke.y = y
		joke.img = joker1Img
		table.insert(joker, joke)
	end
end

function createTimerjoker2(dt, x, y)
	createjokerTimer = createjokerTimer - (1 * dt)
	if createjokerTimer < 0 then
		createjokerTimer = createjokerTimerMax
		joke = {}
		joke.x = x
		joke.y = y
		joke.img = joker2Img
		table.insert(joker, joke)
	end
end

function createTimerjoker3(dt, x, y)
	createjokerTimer = createjokerTimer - (1 * dt)
	if createjokerTimer < 0 then
		createjokerTimer = createjokerTimerMax
		joke = {}
		joke.x = x
		joke.y = y
		joke.img = joker3Img
		table.insert(joker, joke)
	end
end

function createTimerjoker4(dt, x, y)
	createjokerTimer = createjokerTimer - (1 * dt)
	if createjokerTimer < 0 then
		createjokerTimer = createjokerTimerMax
		joke = {}
		joke.x = x
		joke.y = y
		joke.img = joker4Img
		table.insert(joker, joke)
	end
end

function createTimerjoker5(dt, x, y)
	createjokerTimer = createjokerTimer - (1 * dt)
	if createjokerTimer < 0 then
		createjokerTimer = createjokerTimerMax
		joke = {}
		joke.x = x
		joke.y = y
		joke.img = joker5Img
		table.insert(joker, joke)
	end
end

function createTimerjoker6(dt, x, y)
	createjokerTimer = createjokerTimer - (1 * dt)
	if createjokerTimer < 0 then
		createjokerTimer = createjokerTimerMax
		joke = {}
		joke.x = x
		joke.y = y
		joke.img = joker6Img
		table.insert(joker, joke)
	end
end

function positionjoker(dt)
	for q, joke in ipairs(joker) do
		joke.y = joke.y + (220 * dt)
		if joke.y > 1100 then 
			table.remove(joker, q)
		end
	end
end

--vidas
function vidascre(dt)
	if isAlive then
		createheartTimer = createheartTimer - (1 * dt)
		if createheartTimer < 0 then
			createheartTimer = createheartTimerMax
			randomNumber = math.random(10, love.graphics.getWidth() - 10)
			newheart = { x = randomNumber, y = -10, img = vidasImg }
			table.insert(vidas, newheart)
		end
	end
end

function positionheart(dt)
	for i, heart in ipairs(vidas) do
		heart.y = heart.y + (280 * dt)
		if heart.y > 1100 then 
			table.remove(vidas, i)
		end
	end
end

--parachute
function parachute()
	soldado = soldado + 1
	if soldado < 2 then 
		soldier = { x = player.x + 20, y = player.y + 20, img = parachuteImg }
		table.insert(soldiparachute, soldier)
	end
end

function positionparachute(dt)
	for i, soldier in ipairs(soldiparachute) do
		soldier.y = soldier.y + (280 * dt)
		if soldier.y > 1100 then 
			table.remove(soldiparachute, i)
		end
	end
end

--bullets, solo está la posición porque su creación se encuentra más abajo
function positionbullet(dt)
	for i, bullet in ipairs(bullets) do
		bullet.y = bullet.y - (bullet.dy * dt)
		bullet.x = bullet.x + (bullet.dx * dt)
		if bullet.bulletType == 1 then
		--remove bullets
			if bullet.y < 0 then 
				table.remove(bullets, i)
				balas = balas -1
			elseif bullet.x < 0 then 
				table.remove(bullets, i)
				balas = balas -1
			elseif bullet.y > 1100 then 
				table.remove(bullets, i)
				balas = balas -1
			elseif bullet.x > 1920 then 
				table.remove(bullets, i)
				balas = balas -1
			end
		else
			if bullet.y < 0 then 
				table.remove(bullets, i)
			elseif bullet.x < 0 then 
				table.remove(bullets, i)
			elseif bullet.y > 1100 then 
				table.remove(bullets, i)
			elseif bullet.x > 1920 then 
				table.remove(bullets, i)
			end
		end		
	end
end


--collisiones
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
        x2 < x1+w1 and
        y1 < y2+h2 and
        y2 < y1+h1
end

function collisionexplosion1ali(dt)
	for k, alien in ipairs(aliens) do
		for g, explosion2 in ipairs(explosions2) do
			if CheckCollision(explosion2.x, explosion2.y, 150, 150, alien.x, alien.y, alien.img:getWidth(), alien.img:getHeight()) and isAlive then
				table.remove(aliens, k)
			end
		end
	end
end	

function collisionexplosion1ene(dt)
	for i, enemy in ipairs(enemies) do
		for g, explosion2 in ipairs(explosions2) do
			if CheckCollision(explosion2.x, explosion2.y, 150, 150, enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight()) and isAlive then
				table.remove(enemies, i)
			end
		end
	end
end	

function collisionexplosion1player(dt)
	for g, explosion2 in ipairs(explosions2) do
		if CheckCollision(explosion2.x, explosion2.y, 150, 150, player.x, player.y, player.img:getWidth(), player.img:getHeight()) and isAlive then
		corazones = corazones - 1
			if corazones > 0 then 
				isAlive = true
			else
				isAlive = false
			end
		end
	end
end	

function collisionsbullet(dt, score1)
	for j, bullet in ipairs(bullets) do
		if bullet.bulletType == 1 then
			for i, enemy in ipairs(enemies) do
				if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
					table.remove(bullets, j)
					newExplosion(enemy.x, enemy.y)
					newExplosion_lado(enemy.x, enemy.y)
					newExplosion_ariba(enemy.x, enemy.y)
					table.remove(enemies, i)	
					enemigos = enemigos + 1
					comodinType = love.math.random(0, 20)
					if comodinType == 19 then
						createTimerjoker6(dt, enemy.x, enemy.y)
					elseif comodinType == 1 or comodinType == 2 then
						createTimerjoker2(dt, enemy.x, enemy.y)
					elseif comodinType == 3 or comodinType == 4 then
						createTimerjoker3(dt, enemy.x, enemy.y)
					elseif comodinType == 5 or comodinType == 6 then
						createTimerjoker4(dt, enemy.x, enemy.y)
					elseif comodinType == 7 or comodinType == 8 then
						createTimerjoker5(dt, enemy.x, enemy.y)
					else
						createTimerjoker1(dt, enemy.x, enemy.y)
					end
					score = score + 1
				end
			end
			
			for k, alien in ipairs(aliens) do
				if CheckCollision(alien.x, alien.y, alien.img:getWidth(), alien.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
					table.remove(bullets, j)
					table.remove(aliens, k)	
					heartmalcreate(dt, alien.x, alien.y)
					score = score + 1
					newExplosion(alien.x, alien.y)
				end
			end
		else
			if debug == false then
				if CheckCollision(player.x, player.y, player.img:getWidth(), player.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
					table.remove(bullets, j)
					table.remove(player, i)
					newExplosion_i(player.x, player.y)
					newExplosion_j(player.x, player.y)
					newExplosion_k(player.x, player.y)
					newExplosion_l(player.x, player.y)
					newExplosion_m(player.x, player.y)
					comodin = 1
					choque:play()
					corazones = corazones - 1
					if corazones > 0 then 
						isAlive = true
					else
						isAlive = false
					end
				end
			end
		end
	end
end

function collisionsplayer_enemy(dt)
	for i, enemy in ipairs(enemies) do
		if CheckCollision(enemy.x + 5, enemy.y + 5, enemy.img:getWidth() - 5, enemy.img:getHeight() - 5, player.x, player.y, player.img:getWidth(), player.img:getHeight()) and isAlive then
			table.remove(enemies, i)
			choque:play()
			newExplosion_i(player.x, player.y)
			newExplosion_j(player.x, player.y)
			newExplosion_k(player.x, player.y)
			newExplosion_l(player.x, player.y)
			newExplosion_m(player.x, player.y)
			comodin = 1
			corazones = corazones - 1
			if corazones > 0 then 
				isAlive = true
			else
				isAlive = false
			end
		end
	end
end

function collisionsplayer_alien(dt)
	for k, alien in ipairs(aliens) do
		if CheckCollision(alien.x + 15, alien.y + 10, alien.img:getWidth() - 15, alien.img:getHeight() - 10, player.x, player.y, player.img:getWidth(), player.img:getHeight()) and isAlive then
			table.remove(alien, k)
			choque:play()
			newExplosion_i(player.x, player.y)
			newExplosion_j(player.x, player.y)
			newExplosion_k(player.x, player.y)
			newExplosion_l(player.x, player.y)
			newExplosion_m(player.x, player.y)
			comodin = 1
			corazones = corazones - 1
			if corazones > 0 then 
				isAlive = true
			else
				isAlive = false
			end
		end
	end
end
			
function collisionsvidas_player(dt)
	for g, heart in ipairs(vidas) do
		if CheckCollision(player.x, player.y, player.img:getWidth(), player.img
:getHeight(), heart.x, heart.y, heart.img:getWidth(), heart.img:getHeight()) and isAlive then
			table.remove(vidas, g)
			atrapavida:play()
			corazones = corazones + 1
			if corazones > 5 then
				corazones = 5
			end
			
		end
	end
end	

function collisionsheartmal_player(dt)
	for g, malheart in ipairs(heartmal) do
		if CheckCollision(player.x, player.y, player.img:getWidth(), player.img:getHeight(), malheart.x, malheart.y, malheart.img:getWidth(), malheart.img:getHeight()) and isAlive then
			table.remove(heartmal, g)
			newExplosion_i(player.x, player.y)
			newExplosion_j(player.x, player.y)
			newExplosion_k(player.x, player.y)
			newExplosion_l(player.x, player.y)
			newExplosion_m(player.x, player.y)
			choque:play()
			corazones = corazones - 1
			if corazones > 0 then 
				isAlive = true
			else
				isAlive = false
			end
		end
	end
end			
			
function collisionsjoker_player(dt)
	for q, joke in ipairs(joker) do
		if CheckCollision(joke.x, joke.y, joke.img:getWidth(), joke.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) and isAlive then
		atrapaestrella:play()
			if  joke.img == joker6Img then
				comodin = 6
			elseif joke.img == joker2Img then
				comodin = 2
			elseif joke.img == joker3Img then
				comodin = 3
			elseif joke.img == joker4Img then
				comodin = 4
			elseif joke.img == joker5Img then
				comodin = 5
			else
				comodin = 1
			end
			table.remove(joker, q)
		end
	end
end


--movimiento personaje
function movement(dt)	
	if love.keyboard.isDown("up", "w") then
		player.y = player.y - dt*player.speed
	elseif love.keyboard.isDown("down", "s") then
		player.y = player.y + dt*player.speed
    end
	if love.keyboard.isDown("left", "a") then
		player.x = player.x - dt*player.speed
	elseif love.keyboard.isDown("right", "d") then
		player.x = player.x + dt*player.speed
    end	
end


--creación bullets--
function shoot()
	-- Dos naves
	if comodin == 4 then	
		if love.keyboard.isDown('space') and canShoot then
			newBullet1 = { x = player.x - 28, y = player.y + 30, img = bulletImg4, angle = 0, dy = 340, dx = 0, bulletType = 1 }
			table.insert(bullets, newBullet1)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax
			balas = balas + 1
			newBullet0 = { x = player.x + 104, y = player.y + 30, img = bulletImg4, angle = 0, dy = 340, dx = 0, bulletType = 1 }
			table.insert(bullets, newBullet0)
			gunSound:play()
			canShootTimer = canShootTimerMax	
			balas = balas + 1
		end
	elseif comodin == 1 then
		-- normal
		if love.keyboard.isDown('space') and canShoot then
			newBullet1 = { x = player.x + 37, y = player.y + 10, img = bulletImg, angle = 0, dy = 340, dx = 0, bulletType = 1 }
			table.insert(bullets, newBullet1)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax
			balas = balas + 1
		end
	elseif comodin == 5 then
		--Triple
		if love.keyboard.isDown('space') and canShoot then
			--Centro
			newBullet = { x = player.x + 38, y = player.y + 20, img = bulletImg5, angle = 0, dy = 340, dx = 0, bulletType = 1 }
			table.insert(bullets, newBullet)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax
			balas = balas + 1
			--Izquierda
			newBullet3 = { x = player.x + 7, y = player.y + 20, img = bulletImg5, angle = -0.7, dy = 340, dx = -100, bulletType = 1 }
			table.insert(bullets, newBullet3)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax
			balas = balas + 1
			--Derecha
			newBullet2 = { x = player.x + 70, y = player.y + 20, img = bulletImg5, angle = -5.6, dy = 340, dx = 100, bulletType = 1 }
			table.insert(bullets, newBullet2)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax		
			balas = balas + 1
		end
	elseif comodin == 3 then
		--Lateral
		if love.keyboard.isDown('space') and canShoot then
			--Izquierda
			newBullet = { x = player.x + 4, y = player.y + 20, img = bulletImg3, angle = -0.7, dy = 340, dx = -100, bulletType = 1 }
			table.insert(bullets, newBullet)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax
			balas = balas + 1
			--Derecha
			newBullet2 = { x = player.x + 70, y = player.y + 20, img = bulletImg3, angle = -5.6, dy = 340, dx = 100, bulletType = 1 }
			table.insert(bullets, newBullet2)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax		
			balas = balas + 1
		end
	elseif comodin == 2 then
		--Espalda
		if love.keyboard.isDown('space') and canShoot then
			--Arriba
			newBullet1 = { x = player.x + 38, y = player.y, img = bulletImg2, angle = 0, dy = 340, dx = 0, bulletType = 1 }
			table.insert(bullets, newBullet1)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax
			balas = balas + 1
			--Abajo
			newBullet3 = { x = player.x + 44, y = player.y + 90, img = bulletImg2, angle = 3.1415, dy = -340, dx = 0, bulletType = 1 }
			table.insert(bullets, newBullet3)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax		
			balas = balas + 1
		end
	else
		--Todo
		if love.keyboard.isDown('space') and canShoot then
			--Centro
			newBullet1 = { x = player.x + 35, y = player.y + 5, img = bulletImg6, angle = 0, dy = 340, dx = 0, bulletType = 1 }
			table.insert(bullets, newBullet1)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax
			balas = balas + 1
			--Izquierda_arriba
			newBullet = { x = player.x + 5, y = player.y + 20, img = bulletImg6, angle = -0.7, dy = 340, dx = -100, bulletType = 1 }
			table.insert(bullets, newBullet)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax
			balas = balas + 1
			--Derecha_arriba
			newBullet2 = { x = player.x + 60, y = player.y + 20, img = bulletImg6, angle = -5.6, dy = 340, dx = 100, bulletType = 1 }
			table.insert(bullets, newBullet2)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax		
			balas = balas + 1
			--Abajo
			newBullet3 = { x = player.x + 43, y = player.y + 90, img = bulletImg6, angle = 3.1415, dy = -340, dx = 0, bulletType = 1 }
			table.insert(bullets, newBullet3)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax		
			balas = balas + 1
			--Izquierda_abajo
			newBullet4 = { x = player.x + 43, y = player.y + 90, img = bulletImg6, angle = -2.39244, dy = -340, dx = -100, bulletType = 1 }
			table.insert(bullets, newBullet4)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax
			balas = balas + 1
			--Derecha_abajo
			newBullet5 = { x = player.x + 43, y = player.y + 90, img = bulletImg6, angle = 2.39244, dy = -340, dx = 100, bulletType = 1 }
			table.insert(bullets, newBullet5)
			gunSound:play()
			canShoot = false
			canShootTimer = canShootTimerMax		
			balas = balas + 1
		end	
	end
	if not isAlive then
		parachute()
		if love.keyboard.isDown('r') then
			bullets = {}
			enemies = {}
			aliens = {}
			vidas = {}
			joker = {}
			heartmal = {}
			soldado = 0
			-- reset timers
			canShootTimer = canShootTimerMax
			createEnemyTimer = createEnemyTimerMax
			-- move player back to default position
			player.x = love.graphics:getWidth()/2
			player.y = love.graphics:getHeight()/1.15
			-- reset our game state
			score = 0
			balas = 0
			enemigos = 0
			corazones = 3
			comodin = 1
			isAlive = true
		end
	end
end

 
 --creación bullets enemigos
 function enemyshoot()
	for i, enemy in ipairs(enemies) do
	enemyType = love.math.random(0, 300)
		if enemyType == 2 then
			newBullet20 = { x = enemy.x + 60, y = enemy.y + 100, img = bulletImg, angle = 3.1415, dy = -400, dx = 0, bulletType = 2 }
			table.insert(bullets, newBullet20)
			canShoot = false
			canShootTimer = canShootTimerMax
		end	
	end
end	 
 
 --explosiones del juego
 function newExplosion(x, y)
	explosion = {}
	explosion.valid = true
	aleatorio = math.random (20, 90)
	aleatorio2 = math.random (20, 50)
	explosion.x = x + aleatorio
	explosion.y = y + aleatorio2
	r = math.pi/2 * math.random (0, 3)
	explosion.image = image
	explosion.time = love.timer.getTime( )
	explosion.tFrame = 1/30
	table.insert (explosions, explosion)
	explota:play()
end
 
function newExplosion_lado(x, y)
	explosion = {}
	explosion.valid = true
	aleatorio = math.random (20, 90)
	aleatorio2 = math.random (40, 80)
	explosion.x = x + aleatorio
	explosion.y = y + aleatorio2
	r = math.pi/2 * math.random (0, 3)
	explosion.image = image
	explosion.time = love.timer.getTime( )
	explosion.tFrame = 1/30
	table.insert (explosions, explosion)
	explota:play()
end

function newExplosion_ariba(x, y)
	explosion = {}
	explosion.valid = true
	aleatorio = math.random (20, 90)
	aleatorio2 = math.random (70, 100)
	explosion.x = x + aleatorio
	explosion.y = y + aleatorio2
	r = math.pi/2 * math.random (0, 3)
	explosion.image = image
	explosion.time = love.timer.getTime( )
	explosion.tFrame = 1/30
	table.insert (explosions, explosion)
	explota:play()
end
 
function newExplosion_i(x, y)
	explosion = {}
	explosion.valid = true
	if debug then
		aleatorio = math.random (10, 50)
		aleatorio2 = math.random (5, 50)
		explosion.x = x + aleatorio
		explosion.y = y + aleatorio2
	else
		explosion.x = x + 30
		explosion.y = y + 30
	end
	r = math.pi/2 * math.random (0, 3)
	explosion.image = image
	explosion.time = love.timer.getTime( )
	explosion.tFrame = 1/30
	table.insert (explosions, explosion)
	explota:play()
end
 
function newExplosion_j(x, y)
	explosion = {}
	explosion.valid = true
	if debug then
		aleatorio = math.random (40, 110)
		aleatorio2 = math.random (5, 50)
		explosion.x = x + aleatorio
		explosion.y = y + aleatorio2
	else
		explosion.x = x + 75
		explosion.y = y + 30
	end
	r = math.pi/2 * math.random (0, 3)
	explosion.image = image
	explosion.time = love.timer.getTime( )
	explosion.tFrame = 1/30
	table.insert (explosions, explosion)
	explota:play()
end

 function newExplosion_k(x, y)
		explosion = {}
		explosion.valid = true
		if debug then
			aleatorio = math.random (10, 50)
			aleatorio2 = math.random (50, 100)
			explosion.x = x + aleatorio
			explosion.y = y + aleatorio2
		else
			explosion.x = x + 30
			explosion.y = y + 70
		end
		r = math.pi/2 * math.random (0, 3)
		explosion.image = image
		explosion.time = love.timer.getTime( )
		explosion.tFrame = 1/30
		table.insert (explosions, explosion)
		explota:play()
end
 
function newExplosion_l(x, y)
		explosion = {}
		explosion.valid = true
		if debug then
			aleatorio = math.random (40, 110)
			aleatorio2 = math.random (50, 100)
			explosion.x = x + aleatorio
			explosion.y = y + aleatorio2
		else
			explosion.x = x + 80
			explosion.y = y + 75
		end
		r = math.pi/2 * math.random (0, 3)
		explosion.image = image
		explosion.time = love.timer.getTime( )
		explosion.tFrame = 1/30
		table.insert (explosions, explosion)
		explota:play()
end

function newExplosion_m(x, y)
	explosion = {}
	explosion.valid = true
	if debug then
		aleatorio = math.random (30, 60)
		aleatorio2 = math.random (40, 70)
		explosion.x = x + aleatorio
		explosion.y = y + aleatorio2
	else
		explosion.x = x + 40
		explosion.y = y + 55
	end
	r = math.pi/2 * math.random (0, 3)
	explosion.image = image
	explosion.time = love.timer.getTime( )
	explosion.tFrame = 1/30
	table.insert (explosions, explosion)
	explota:play()
end


--          --
-- Updating --
--          --
function game_update(dt)
	--debug
	if love.keyboard.isDown('m') then
		debug = true
	else
		debug = false
	end
	
	--ejecución funciones
	shoot()
	positionparachute(dt)
	enemyshoot()
	positionbullet(dt)
	createTimerEnemy(dt)
	moveToPlayer(dt)
	positionenemy(dt)
	positionheartmal(dt)
	collisionsbullet(dt, score1)
	if debug == false then
		collisionsplayer_enemy(dt)--
		collisionsplayer_alien(dt)--
		collisionsheartmal_player(dt)--
		collisionexplosion1player(dt)--
	end
	collisionsvidas_player(dt)
	collisionsjoker_player(dt)
	collisionexplosion1ene(dt)
	collisionexplosion1ali(dt)
	movement(dt)
	canTimershoot(dt)
	vidascre(dt)
	positionheart(dt)
	positionjoker(dt)
	createTimeralien(dt)
	createTimerbomba(dt)
	positionbomba(dt)
	if bomb == true then
		createTimerba(dt)
	end
	--Emisión de partículas
	system:update(dt)
end


--         --
-- Drawing --
--         --
function draw_game2()
	--corazones
	if corazones == 1 then
		love.graphics.draw(vidaImg, 20, 20)
	elseif corazones == 2 then
		love.graphics.draw(vidaImg, 20, 20)
		love.graphics.draw(vidaImg, 50, 20)
	elseif corazones == 3 then
		love.graphics.draw(vidaImg, 20, 20)
		love.graphics.draw(vidaImg, 50, 20)
		love.graphics.draw(vidaImg, 80, 20)
	elseif corazones == 4 then
		love.graphics.draw(vidaImg, 20, 20)
		love.graphics.draw(vidaImg, 50, 20)
		love.graphics.draw(vidaImg, 80, 20)
		love.graphics.draw(vidaImg, 110, 20)
	elseif corazones > 4 then
		love.graphics.draw(vidaImg, 20, 20)
		love.graphics.draw(vidaImg, 50, 20)
		love.graphics.draw(vidaImg, 80, 20)
		love.graphics.draw(vidaImg, 110, 20)
		love.graphics.draw(vidaImg, 140, 20)
	else
		love.graphics.setColor(255, 0, 0)
		love.graphics.print("Game over", 20, 20)
	end	
	
	--score
	if score == 0 then 
	    love.graphics.push()	
		love.graphics.setColor(255, 0, 0)
		if ventana == false then
			love.graphics.print("Score: " .. tostring(score), 12, 50)
		else
			love.graphics.print("Score: " .. tostring(score), 12, 50)
		end
		love.graphics.pop()
	else
	    love.graphics.push()	
		love.graphics.setColor(0, 255, 0)
		if ventana == false then
			love.graphics.print("Score: " .. tostring(score), 12, 50)
		else
			love.graphics.print("Score: " .. tostring(score), 12, 50)
		end
		love.graphics.pop()
	end
	
	--Info enemigos y balas
	love.graphics.push()
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Enemies: " .. tostring(enemigos), 12, love.graphics:getHeight()/1.08)
	love.graphics.pop()

	love.graphics.push()
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Bullets: " .. tostring(balas), 12, love.graphics:getHeight()/1.13)
	love.graphics.pop()
	
	--enemy
	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
		if debug then
			love.graphics.rectangle("line", enemy.x, enemy.y, 95, 90)
		end
	end
	--alien
	for i, alien in ipairs(aliens) do
		love.graphics.draw(alien.img, alien.x, alien.y)
		if debug then
			love.graphics.rectangle("line", alien.x, alien.y, 90, 40)
		end
	end
		
	--if isAlive ... 
	if isAlive then
		--player
		love.graphics.draw(player.img, player.x, player.y)
		if debug then
			love.graphics.rectangle("line", player.x, player.y, 84, 90)
		end
		--bomba
		for i, bomba in ipairs(bombas) do
		love.graphics.draw(bomba.img, bomba.x, bomba.y)
		end		
		--heart
		for i, heart in ipairs(vidas) do
			love.graphics.draw(heart.img, heart.x, heart.y)
		end
		--malheart
		for i, malheart in ipairs(heartmal) do
			love.graphics.draw(malheart.img, malheart.x, malheart.y)
			--Emisores de partículas
			love.graphics.draw(system, malheart.x + 18, malheart.y + 10)
		end
		--joker
		for q, joke in ipairs(joker) do
			local img = joke.img
			local x, y = joke.x, joke.y
			love.graphics.draw(img, x, y)
		end
		--comodines
		if comodin == 1 then 
			for i, bullet in ipairs(bullets) do
				love.graphics.draw(bullet.img, bullet.x, bullet.y, bullet.angle)
			end
		end	
		if comodin == 2 then
			for i, bullet in ipairs(bullets) do
				love.graphics.draw(bullet.img, bullet.x, bullet.y, bullet.angle)
			end
		end
		if comodin == 3 then
			for i, bullet in ipairs(bullets) do
				love.graphics.draw(bullet.img, bullet.x, bullet.y, bullet.angle)
			end
		end
		if comodin == 4 then
			for i, bullet in ipairs(bullets) do
				love.graphics.draw(bullet.img, bullet.x, bullet.y, bullet.angle)
				love.graphics.draw(aliadoImg, player.x - 55, player.y + 30)
				love.graphics.draw(aliado2Img, player.x + 77, player.y + 30)
			end
		end
		if comodin == 5 then
			for i, bullet in ipairs(bullets) do
				love.graphics.draw(bullet.img, bullet.x, bullet.y, bullet.angle)
			end
		elseif comodin > 5 then
			for i, bullet in ipairs(bullets) do
				love.graphics.draw(bullet.img, bullet.x, bullet.y, bullet.angle)
			end
		end
		
	else
		--pulsar R
		love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2 - 165, love.graphics:getHeight()/2 - 30)
		--cohete que sale después de que muera nave
		for i, soldier in ipairs(soldiparachute) do
			love.graphics.draw(soldier.img, soldier.x - 20, soldier.y)
			--Emisores de partículas
			love.graphics.draw(system, soldier.x, soldier.y)
		end
	end
		
	--debug	
	if debug then
		fps = tostring(love.timer.getFPS())
		love.graphics.print("Current FPS: "..fps, 12, 90)
	end

	
	--explosiones
	
	--explosion normal
	for i, explosion in ipairs (explosions) do
		local image = explosion.image
		local x, y, r = explosion.x, explosion.y, explosion.r
		local currentFrame = math.floor((love.timer.getTime( ) - explosion.time)/explosion.tFrame)+1
		if frames[currentFrame] then
			love.graphics.draw(explosion.image, frames[currentFrame], x, y, r, 1, 1, 32, 32)
		else
			explosion.valid = false
		end
	end
	--explosion grande
	for i, explosion2 in ipairs (explosions2) do
		local image = explosion2.image
		local x, y, r = explosion2.x, explosion2.y, explosion2.r
		local currentFrame = math.floor((love.timer.getTime( ) - explosion2.time)/explosion2.tFrame)+1
		if frames2[currentFrame] then
			love.graphics.draw(explosion2.image, frames2[currentFrame], x, y, r, 1, 1, 32, 32)
		else
			explosion2.valid = false
			table.remove(explosions2, i)
		end
	end
	
	
	--Fondo en movimiento
	for ñ, star in ipairs (stars) do
		love.graphics.push()
		love.graphics.setColor(star.color)
		love.graphics.rectangle( "fill", star.x, star.y, 2, 3)
		love.graphics.pop()
	end
end
