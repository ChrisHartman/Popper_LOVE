debug = true

playerImg = nil -- this is just for storage
rotation = 0
width = nil
height = nil
ball = {x = 325, y = 325, y_velocity = nil, color = nil, dead = true}
ballColors = {{189, 255, 145}, {255, 233, 145}, {255, 145, 145}, {145, 233, 255}}
gravity = 975
incrementer = math.pi/2
score = 0
colorPopped = 1
missesLeft = 3
scoreFont = love.graphics.newFont("assets/Margot-Regular.ttf", 20)
gameOverFont = love.graphics.newFont("assets/Margot-Regular.ttf", 100)



function love.load(arg)
    playerImg = love.graphics.newImage('assets/spikeball.png')
    width = playerImg:getWidth()
    height = playerImg:getHeight()
    math.randomseed(os.time())
    --we now have an asset ready to be used inside Love
end



function love.update(dt)
	if missesLeft > 0 then
		if love.keyboard.isDown('left') then
			rotation = rotation - (math.pi/1.5 *dt)
		elseif love.keyboard.isDown('right') then
			rotation = rotation + (math.pi/1.5 * dt)
		end
		if ball.dead then
			ball.y_velocity = 600
			ball.y = 325
			ball.color = math.random(4)
			ball.dead = false
		else
			ball.y = ball.y - ball.y_velocity*dt
			ball.y_velocity = ball.y_velocity - gravity * dt
		end
		if ball.y > 600 then
			ball.dead = true
			colorPopped = math.ceil((rotation/incrementer)%4)
			if colorPopped == ball.color then
				score = score + 1
			else
				if missesLeft > 0 then
					missesLeft = missesLeft - 1
				end
			end
		end
	elseif love.keyboard.isDown('return') then
		missesLeft = 3
		ball.dead = true
		score = 0
	end
end

function love.draw(dt)
   
    love.graphics.setColor(ballColors[ball.color])
    
    love.graphics.circle("fill", ball.x, ball.y, 5, 10) -- Draw white circle with 100 segments.
    

    love.graphics.setFont(scoreFont)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(playerImg, 325, 325 , rotation, 1, 1, width / 2, height / 2)
    if missesLeft > 0 then
    	love.graphics.print("Score: " .. score .. "\nMisses left: " .. missesLeft, 25, 25)
    else
    	love.graphics.setFont(gameOverFont)
    	love.graphics.print("GAME OVER\n   Score: " .. score, 40, 250, 0)
    end
    --Canvas:clear()
end

