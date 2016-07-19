function love.load(arg)
   -- Load graphics
   popSound  = love.audio.newSource('assets/pop.ogg', static)
   playerImg = love.graphics.newImage('assets/spikeball.png')
   scoreFont = love.graphics.newFont("assets/Margot-Regular.ttf", 20)
   gameOverFont = love.graphics.newFont("assets/Margot-Regular.ttf", 100)
   
   -- Declare constants
   PLAYER_WIDTH = playerImg:getWidth()
   PLAYER_HEIGHT = playerImg:getHeight()
   BALL_COLORS = {{189, 255, 145}, {255, 233, 145}, {255, 145, 145}, {145, 233, 255}}
   GRAVITY = 975
   COLOR_ARC_LENGTH = math.pi / 2
   ROTATION_VELOCITY = math.pi / 1.5
   
   -- Initialize variables
   ball = {x = 325, y = 325, y_velocity = nil, color = nil, dead = true}
   restart()
   
   -- Seed random
   math.randomseed(os.time())
end

function love.update(dt)
   if missesLeft > 0 then
      checkpause(dt)
      
      if paused then return end
      
      rotateSpikeBall(dt)
      
      -- Creates a new ball if there isn't one, otherwise moves ball
      if ball.dead then
	 newBall()
      else
	 ball.y = ball.y - ball.y_velocity*dt
	 
	 ball.y_velocity = ball.y_velocity - GRAVITY * dt
      end
      
      checkCollision()
   elseif love.keyboard.isDown('return', 'space') then
      restart()
   end
end

function rotateSpikeBall(dt)
   if love.keyboard.isDown('left') then
      rotation = rotation - (ROTATION_VELOCITY *dt)
   elseif love.keyboard.isDown('right') then
      rotation = rotation + (ROTATION_VELOCITY * dt)
   end
end

function newBall()
   ball.y_velocity = 600

   ball.y = 325

   ball.color = math.random(4)

   ball.dead = false

   popSound:play()
end

function restart()
   missesLeft = 3
   
   rotation = 0

   ball.dead = true

   score = 0

   pausetime = 0

   paused = false
end


function checkpause(dt)
   pausetime = pausetime + dt
   
   if love.keyboard.isDown('space') and pausetime > .2 then
      paused = not paused

      pausetime = 0
   end
end

-- Check if ball has been popped and if it was popped on the right color
-- increment score or decrement missesLeft accordingly
function checkCollision()
   if ball.y > 575 then
      ball.dead = true
      
      colorPopped = math.ceil((rotation / COLOR_ARC_LENGTH) % 4)
		
      if colorPopped == ball.color then
	 score = score + 1
      else
	 missesLeft = missesLeft - 1
      end
   end
end

function love.draw(dt)
   -- Draw ball
   love.graphics.setColor(BALL_COLORS
			  [ball.color])
   love.graphics.circle("fill", ball.x, ball.y, 5, 10) 
   
   -- Clear the color and draws the spikeball (last to make sure it hides the ball behind it)
   love.graphics.setColor(255, 255, 255)
   love.graphics.draw(playerImg, 325, 325 , rotation, 1, 1, PLAYER_WIDTH / 2, PLAYER_HEIGHT / 2)
    
   -- Draw text
   if missesLeft > 0 then
      love.graphics.setFont(scoreFont)
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
