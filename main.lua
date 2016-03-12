  debug = true



function love.load(arg)
	-- Graphics loading
	popSound  = love.audio.newSource('assets/pop.ogg', static)
    playerImg = love.graphics.newImage('assets/spikeball.png')
    scoreFont = love.graphics.newFont("assets/Margot-Regular.ttf", 20)
	gameOverFont = love.graphics.newFont("assets/Margot-Regular.ttf", 100)

	-- Constants
    width = playerImg:getWidth()
    height = playerImg:getHeight()
    incrementer = math.pi/2
	ballColors = {{189, 255, 145}, {255, 233, 145}, {255, 145, 145}, {145, 233, 255}}
	gravity = 975

    -- Variable initialization 
    rotation = 0
    score = 0
    missesLeft = 3
    paused = false
    pausetime = 0
    
    ball = {x = 325, y = 325, y_velocity = nil, color = nil, dead = true}

    -- Seed random
    math.randomseed(os.time())
end



function love.update(dt)

	if missesLeft > 0 then
		checkpause(dt)
		if paused then return end
		-- rotate spike ball based on input
		rotateSpikeBall(dt)
		-- Creates a new ball if there isn't one, otherwise moves ball
		if ball.dead then
			newBall()
		else
			ball.y = ball.y - ball.y_velocity*dt
			ball.y_velocity = ball.y_velocity - gravity * dt
		end
		checkCollision()
	-- Restart on enter or space
	elseif love.keyboard.isDown('return', 'space') then
		missesLeft = 3
		ball.dead = true
		score = 0
		pausetime = 0
	end
end

function rotateSpikeBall(dt)
	if love.keyboard.isDown('left') then
			rotation = rotation - (math.pi/1.5 *dt)
	elseif love.keyboard.isDown('right') then
			rotation = rotation + (math.pi/1.5 * dt)
	end
end

function newBall()
	ball.y_velocity = 600
	ball.y = 325
	ball.color = math.random(4)
	ball.dead = false
	popSound:play()
end

function checkpause(dt)
	pausetime = pausetime + dt
	if love.keyboard.isDown('space') and pausetime > .2 then
		paused = not paused
		pausetime = 0
	end
end




-- Checks if ball has been popped and if it was popped on the right color
-- increments score or decrements missesLeft accordingly
function checkCollision()
	if ball.y > 575 then
		ball.dead = true
		colorPopped = math.ceil((rotation/incrementer)%4) -- which quadrant the ball is in
		if colorPopped == ball.color then
			score = score + 1
		else
			missesLeft = missesLeft - 1
		end
	end
end

function love.draw(dt)
	
   	-- Draw ball
   	-- love.graphics.print(pausetime, 20, 20, 0)
    love.graphics.setColor(ballColors[ball.color])
    love.graphics.circle("fill", ball.x, ball.y, 5, 10) -- Draw white circle with 100 segments.
    
    -- Clears the color and draws the spikeball (last to make sure it hides the ball behind it)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(playerImg, 325, 325 , rotation, 1, 1, width / 2, height / 2)

    -- Draw score
    if missesLeft > 0 then
    	love.graphics.setFont(scoreFont) --Don't like loading the font every time, could be problematic in different games
    	love.graphics.print("Score: " .. score .. "\nMisses left: " .. missesLeft, 25, 25)
    	if paused then 
			love.graphics.setFont(gameOverFont)
			love.graphics.print("PAUSED", 135, 250, 0)
		end
    else
    	love.graphics.setFont(gameOverFont)
    	love.graphics.print("GAME OVER\n   Score: " .. score, 40, 250, 0)
    end
end

