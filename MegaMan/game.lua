--Mega Man Game
--Author: Paul Whisler
--Date Started: 3/12/08
--Date Completed: ?/?/??
--==========================================================================================================
dofile("./Scripts/animLibDaaa.lua")
dofile("./Scripts/animFunc.lua")
dofile("./Scripts/data.lua")
dofile("./Scripts/collision.lua")
dofile("./Scripts/enemyFunctions.lua")
dofile("./Scripts/playerFunctions.lua")
dofile("./Scripts/mainMenu.lua")
--==========================================================================================================
function checkBG()
--//this function checks to see what screen the player is on, and will change the background image and set up player and enemy positions//
--//if level 1 do these checks//
if stage == 1 then
	--if on right edge
	if Player[2].x > 447 then
		if currentBG == 1 then
			bg = Image.load("Images/Backgrounds/city2.png")
			currentBG = 2
			Player[2].x = 5
			currentEnemy = 2
			setEnemyAnimation("alive",currentEnemy)
			stopBullets()	
			newX = Enemy[3].x
		elseif currentBG == 2 then
			bg = Image.load("Images/Backgrounds/city3.png")
			currentBG = 3
			Player[2].x = 5
			currentEnemy = 3
			setEnemyAnimation("alive",currentEnemy)
			stopBullets()	
			Player[2].y = 95 
			newX = Enemy[3].x
		elseif currentBG == 3 then
			score = score + 5000
			levelTimer:stop()
			levelTime = levelTimer:time()
			timeBonus = 600,000 - levelTime
			score = score + timeBonus
			stage = 2
			gameState = "stageClear"
		end
	--if on left edge
	elseif Player[2].x < 1 then
		if currentBG == 2 then
			bg = Image.load("Images/Backgrounds/city1.png")
			currentBG = 1
			Player[2].x = 445
			currentEnemy = 1
			setEnemyAnimation("alive",currentEnemy)
			stopBullets()	
			newX = Enemy[3].x
		elseif currentBG == 3 then
			bg = Image.load("Images/Backgrounds/city2.png")
			currentBG = 2
			Player[2].x = 445
			currentEnemy = 2
			setEnemyAnimation("alive",currentEnemy)
			stopBullets()	
			newX = Enemy[3].x
		elseif currentBG == 1 then
			Player[2].x = 0
		end
	end
--//if on level 2, do these background checks//
elseif stage == 2 then
	--do these checks on stage 2
	if Player[2].x > 447 then
		if currentBG == 4 then
			bg = Image.load("Images/Backgrounds/bg2.png")
			currentBG = 5
			Player[2].x = 5
			currentEnemy = 2
			setEnemyAnimation("alive",currentEnemy)
			stopBullets()	
			newX = Enemy[3].x
		elseif currentBG == 5 then
			bg = Image.load("Images/Backgrounds/bg3.png")
			currentBG = 6
			Player[2].x = 5
			currentEnemy = 3
			setEnemyAnimation("alive",currentEnemy)
			stopBullets()	
			Player[2].y = 95 
			newX = Enemy[3].x
		elseif currentBG == 6 then
			score = score + 5000
			levelTimer:stop()
			levelTime = levelTimer:time()
			timeBonus = 600,000 - levelTime
			score = score + timeBonus
			gameState = "stageClear"
		end
	--if on left edge
	elseif Player[2].x < 1 then
		if currentBG == 5 then
			bg = Image.load("Images/Backgrounds/bg1.png")
			currentBG = 4
			Player[2].x = 445
			currentEnemy = 1
			setEnemyAnimation("alive",currentEnemy)
			stopBullets()	
			newX = Enemy[3].x
		elseif currentBG == 6 then
			bg = Image.load("Images/Backgrounds/bg2.png")
			currentBG = 5
			Player[2].x = 445
			currentEnemy = 2
			setEnemyAnimation("alive",currentEnemy)
			stopBullets()	
			newX = Enemy[3].x
		elseif currentBG == 4 then
			Player[2].x = 0
		end
	end
--end of stage checking
end
--end of function
end
--==========================================================================================================
function bulletSetup()
	--Increase the current bullet by one, or reset it to 1--
	if currentBullet < 3 then
		currentBullet = currentBullet + 1
	else
		currentBullet = 1
	end
	--if the current bullet is  not being fired, then its starting position should be at the player--
	if BulletInfo[currentBullet].firing == false then	
		if BulletInfo[currentBullet].direction == "left" then
			BulletInfo[currentBullet].x = Player[2].x
			BulletInfo[currentBullet].y = Player[2].y + 4
		elseif BulletInfo[currentBullet].direction == "right" then
			BulletInfo[currentBullet].x = Player[2].x + 32
			BulletInfo[currentBullet].y = Player[2].y + 4
		end
	end
	BulletInfo[currentBullet].direction = Player[2].dir
	BulletInfo[currentBullet].firing = true
end
--==========================================================================================================
function bulletFire()
	for i = 1,3 do
		if BulletInfo[i].firing == true then
			if BulletInfo[i].direction == "right" then BulletInfo[i].x = BulletInfo[i].x + 6 end
			if BulletInfo[i].direction == "left" then BulletInfo[i].x = BulletInfo[i].x - 6 end
			screen:blit(BulletInfo[i].x,BulletInfo[i].y,BulletInfo[i].pic)
			bull.x = BulletInfo[i].x
			bull.y = BulletInfo[i].y
			currentBullet = i
		end
		if BulletInfo[i].x < 0 or BulletInfo[i].x > 480 or Enemy[currentEnemy].state == "hit"  then --or Enemy[currentEnemy].state == "dead"
			BulletInfo[i].firing = false	
		end
	end
end
--==========================================================================================================
--if you switch screens, all bullets should stop
function stopBullets()	
	for i = 1,3 do
		BulletInfo[i].firing = false
	end
end
--==========================================================================================================

oldpad = Controls.read()


collisionSet = false

Music.playFile("Audio/bgm2.xm", true)

--*****Main Loop*****--
while true do


--clears the screen
screen:clear()

if gameState == "game" then
--draw background
screen:blit(0,0,bg)


-- draws players stats
-- first draw the stats hold
screen:blit(0,175,statsHolder)
-- second draw lives left
yPos = 190
for i=1,Player[2].livesLeft do
	screen:blit(65,yPos,lives)
	yPos = yPos + 25
end
-- third draw the health bar and the health that goes inside it
yPos = 240
fill = .05 * Player[2].health
screen:blit(5,185,healthBar)
for i = 1,fill do
	screen:blit(22,yPos,health)
	yPos = yPos - 5
end
--end

if(currentBG == 3 and collisionSet == false) then
	collisionSet = true
	
else
	if stage == 1 then
		grd.x = 0
		grd.y = 170
		if currentBG ~= 3 then
			--screen:blit(0,grd.y,groundImage)
			collisionSet = false
			ground = 120
		else
			--//this will draw the collision boxes of level 1 screen 3, uncomment to view//
			--[[
			screen:blit(grd1.x,grd1.y,groundImage1)
			screen:blit(grd2.x,grd2.y,groundImage2)
			screen:blit(grd3.x,grd3.y,groundImage3)
			screen:blit(grd4.x,grd4.y,groundImage4)
			screen:blit(grd5.x,grd5.y,groundImage5)
			screen:blit(grd6.x,grd6.y,groundImage6)
			screen:blit(grd7.x,grd7.y,groundImage7)
			screen:blit(grd8.x,grd8.y,groundImage8)
			screen:blit(grd9.x,grd9.y,groundImage9)--]]
		end
	elseif stage == 2 then
		if currentBG ~= 6 then
			grd.x = 0
			grd.y = 110
			--screen:blit(0,grd.y,groundImage)
		else
			grd.x = 0
			grd.y = 130
			--screen:blit(0,grd.y,groundImage)
		end
		ground = grd.y
	end
end

--call game functions
playerMovement()
playerActions()
checkBG()
bulletFire()
enemyMovement(currentEnemy)

if isJumping == true then
	playerJump()
end

--draw the player
Player[2].animTable[1]:update()
Player[2].animTable[1]:blit(screen, Player[2].x, Player[2].y)
currentPlayerFrame = Player[2].animTable[1]:getFrame()


--if there are enemies left, then draw them to the screen
if currentEnemy <= numberOfEnemies then 
	Enemy[currentEnemy].animTable[1]:update()
	Enemy[currentEnemy].animTable[1]:blit(screen, Enemy[currentEnemy].x, Enemy[currentEnemy].y)
	currentEnemyFrame = Enemy[currentEnemy].animTable[1]:getFrame()
	
	--keep shooting bullet while the fat bot is still alive
	if Enemy[3].state == "alive" then
		--enemy bullet
		Enemy[10].animTable[1]:update()
		Enemy[10].animTable[1]:blit(screen,newX,ground)
		Enemy[10].x = newX
		newX = newX - 2
		if newX < 0 then
			newX = Enemy[3].x
		end
		--set up the collision to be the same as the image
		orb.x = Enemy[10].x
		orb.y = Enemy[10].y
	end
	
end

--these are for collision checking
ply.x = Player[2].x
ply.y = Player[2].y
emy.x = Enemy[currentEnemy].x
emy.y = Enemy[currentEnemy].y
----------------------------------------------
if Enemy[currentEnemy].state == "dead" then
	--move enemy to bottom of screen
	if Enemy[currentEnemy].y <= 272 then
		Enemy[currentEnemy].y = Enemy[currentEnemy].y + 5
	end
end
----------------------------------------------
--COLLISION CHECKS--
if currentEnemy <= numberOfEnemies then
----------------------------------------------
--check for collision between the player and an enemy--
	if collision(ply, emy) and Enemy[currentEnemy].state ~= "hit" and playerState ~= "hit" then 
		hitSound:play()
		score = score - 10
		playerState = "hit"
		if Player[2].dir == "right" then
			Player[2].x = Player[2].x - 20
		else
			Player[2].x = Player[2].x + 20
		end
		setPlayerAnimation("hit")
		counter:start()
		Player[2].health = Player[2].health - 10
	end
----------------------------------------------
--check for collision between the bullet and an enemy--
	if collision(bull, emy) and Enemy[currentEnemy].state ~= "dead" and Enemy[currentEnemy].state ~= "hit" and BulletInfo[currentBullet].firing == true--[[  ]] then
		Enemy[currentEnemy].state = "hit"
		dealDamage()
		BulletInfo[currentBullet].firing = false
		score = score + 100
	end
else
	currentEnemy = currentEnemy - 1
end
----------------------------------------------
--check collision between player and the enemy's bullet
	if collision(ply,orb) and playerState ~= "hit" then
		hitSound:play()
		playerState = "hit"
		if Player[2].dir == "right" then
			Player[2].x = Player[2].x - 20
		else
			Player[2].x = Player[2].x + 20
		end
		setPlayerAnimation("hit")
		counter:start()
		Player[2].health = Player[2].health - 20
		score = score - 50
	end
----------------------------------------------
ply.x = Player[2].x
ply.y = Player[2].y
--check collision with the ground
--box collision check first, then if that succeeds then do the per pixel check
if currentBG == 3 then
	if collision(ply,grd1) and collision(ply, grd2) then 
		--screen:print(200,200,"Collision With Ground1 & 2",white)
		ground = grd1.y -55
		Player[2].x = grd2.x -30
	elseif collision(ply, grd1) then
		--screen:print(200,200,"Collision With Ground1",white)
		ground = grd1.y - 40
	elseif collision(ply, grd3) then
		--screen:print(200,200,"Collision With Ground3",white)
		ground = grd3.y -40
	elseif collision(ply, grd4) and collision(ply,grd5) then
		--screen:print(200,200,"Collision With Ground4 & 5",white)
		ground = grd4.y -40
		Player[2].x = grd5.x --35
	elseif collision(ply, grd4) then
		--screen:print(200,200,"Collision With Ground4",white)
		ground = grd4.y -40
	elseif collision(ply, grd6) and collision(ply,grd7) then
		--screen:print(200,200,"Collision With Ground6 & 7",white)
		ground = grd6.y -40
		Player[2].x = grd7.x -30
	elseif collision(ply, grd6) then
		--screen:print(200,200,"Collision With Ground6",white)
		ground = grd6.y -40
	elseif collision(ply, grd8) then
		--screen:print(200,200,"Collision With Ground8",white)
		ground = grd8.y -40
	elseif collision(ply, grd9) then
		--screen:print(200,200,"Collision With Ground9",white)
		ground = grd9.y -40
	else
		if playerState ~= "jumping" and playerState ~= "standing" then
			Player[2].y = Player[2].y + 7
			playerState = "falling"
		end
	end
else--if any bg other than 3 which has holes to fall so special collision
	if collision(ply, grd) then
		--do nothing
	else
		--if he isn't jumping, make him fall
		if playerState ~= "jumping" then
			Player[2].y = grd.y-50
			--playerState = "falling"
		end
	end
end

-----------------------------------
--if the player dies, show death animation and reduce # of lives
if (Player[2].health <= 0 or Player[2].y > 500) and (Player[2].livesLeft > 0) then
	megaManDeadSound:play()
	score = score - 75
	setPlayerAnimation("dead")
	counter:start()
	playerState = "hit"
	Player[2].livesLeft = Player[2].livesLeft -1
	--have to reset the health if you have any lives left
	if Player[2].livesLeft > 0 then
		Player[2].health = 100
		--because the last bg has holes you could fall in, we'll reset the player's position to a safe spot
		if currentBG == 3 then
			Player[2].x = 25
			Player[2].y = 0
		end
	else
		--no more lives left so end game
		gameState = "gameOver"
	end
end
-----------------------------------
--take care of timers which are used to allow an animation to finish playing before state is changed
currentTime = counter:time()

--if playerState == "hit" or playerState == "shooting" then
if currentTime > 1500 then
	counter:reset(0)
	if (playerState == "hit" or playerState == "shooting") and Player[2].livesLeft >=0 then
		playerState = "standing"
		setPlayerAnimation("stand")
	end
end
--end
-------------------------------------
--//Print Player info to screen//
--screen:print(19,39, "Row-column: ("..Player[2].animTable[1]:getRow()..", "..Player[2].animTable[1]:getColumn()..")", white)
--screen:print(19,49, "Num of frames: "..Player[2].animTable[1]:getNbFrames(),white)
screen:print(200,19,"Ply X: "..Player[2].x.." ,Ply Y: "..Player[2].y,white)
--screen:print(200,29,"Emy X: "..Enemy[currentEnemy].x.." ,Emy Y: "..Enemy[currentEnemy].y,white)
--screen:print(200,29,"Player Lives: "..Player[2].livesLeft,blue)
--screen:print(200,39,"Timer="..currentTime,blue)
--screen:print(200,49,"Ply Health: "..Player[2].health,blue)
--screen:print(200,59,"Emy Health: "..Enemy[currentEnemy].health,white)
--screen:print(19,29,"Enemy state= "..Enemy[currentEnemy].state,white)
--screen:print(100,100,"CurrentBG = "..currentBG,white)
screen:print(0,20,"stage: "..stage,white)
screen:print(0,30,"ground: "..ground,white)
--Print bullet info to screen.
--screen:print(200,190,"Bullet 1: ".. tostring(BulletInfo[1].firing).." x: "..BulletInfo[1].x,white)
--screen:print(200,200,"Bullet 2: "..tostring(BulletInfo[2].firing).." x: "..BulletInfo[1].x,white)
--screen:print(200,210,"Bullet 3: "..tostring(BulletInfo[3].firing).." x: "..BulletInfo[1].x,white)
--screen:print(200,60,"Direction: "..BulletInfo[currentBullet].direction,green)
--screen:print(200,60, "enemy image: "..Enemy[2].animTable[1].getImageName(),white)


screen.waitVblankStart()
screen.flip()
oldpad = pad

else
	menu()
	playerMovement()	
	screen.waitVblankStart()
	screen.flip()
	oldpad = pad

-- end of if in the game condition check
end
--end of main loop
end
--==========================================================================================================
--==========================================================================================================
--==========================================================================================================


