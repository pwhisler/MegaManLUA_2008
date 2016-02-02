function takeDamage()
	--if player is hit, minus their health and check if they are dead
end
--==========================================================================================================
--==========================================================================================================
function playerJump()
	--screen:print(19,29,"velocity= "..velocity,Color.new(0,245,5))
	if velocity > -20 then
		velocity = velocity + acceleration
		Player[2].y = Player[2].y - velocity
		playerState = "jumping"
	end
	if Player[2].y >= ground then
		velocity = 15
		accerlation = -1
		isJumping = false
		playerState = "standing"
		playerMovement()
		playerActions()
		if playerState == "standing" then
			setPlayerAnimation("stand")
		elseif playerState == "walking" then
			setPlayerAnimation("walk")
		end
		Player[2].y = ground
	end
end
--==========================================================================================================
--==========================================================================================================
function playerActions()
	cont = Controls.read()
	---------------------------X-------------------------------------------------
	if (cont:cross()) and (playerState ~= "jumping") and (oldpad:cross() ~= cont:cross()) and playerState ~= "hit" and playerState ~= "falling" then
		jumpSound:play()
		isJumping = true
		isStanding = false
		setPlayerAnimation("jump")
	---------------------------[]--------------------------------------------------
	end

end
--==========================================================================================================
--function for player movement/controls
function playerMovement()
	pad = Controls.read()
	-----------------------------------------------------------------------------
	-- Main Menu
	-----------------------------------------------------------------------------
	if gameState ~= "game" and gameState ~= "stageClear" and gameState ~= "gameOver" then
		if pad:cross() and gameState == "titleScreen"  then
			gameState = "gameStart"
		elseif pad:down() and oldpad:down() ~= pad:down() and gameState == "gameStart" then
			gameState = "continue"
		elseif pad:down() and oldpad:down() ~= pad:down() and gameState == "continue" then
			gameState = "option"
		elseif pad:down() and oldpad:down() ~= pad:down() and gameState == "option" then
			gameState = "gameStart"
		elseif pad:cross() and oldpad:cross() ~= pad:cross() and gameState == "gameStart" then
			gameState = "game"
		elseif pad:up() and oldpad:up() ~= pad:up() and gameState == "gameStart" then
			gameState = "option"
		elseif pad:up() and oldpad:up() ~= pad:up() and gameState == "continue" then
			gameState = "gameStart"
		elseif pad:up() and oldpad:up() ~= pad:up() and gameState == "option" then
			gameState = "continue"
		elseif pad:cross() and oldpad:cross() ~= pad:cross() and gameState == "gameStart" then
			gameState = "game"
		end
	-----------------------------------------------------------------------------
	-- In Game
	-----------------------------------------------------------------------------
	elseif gameState == "game" then
		----------------------->------------------------------------------------------and playerState ~= "jumping"   and playerState ~= "hit"
		if pad:right() and oldpad:right() ~= pad:right() and playerState ~= "hit" then
			playerState = "walking"
			isStanding = false
			Player[2].dir = "right"
			setPlayerAnimation("walk")
		elseif pad:right() and playerState ~= "hit" then
			playerState = "walking"
			Player[2].x = Player[2].x + 3
		------------------------<-----------------------------------------------------
		elseif pad:left() and oldpad:left() ~= pad:left() and playerState ~= "hit" then
			playerState = "walking"
			isStanding = false
			Player[2].dir = "left"
			setPlayerAnimation("walk")
		elseif pad:left() and playerState ~= "hit" then
			playerState = "walking"
			Player[2].x = Player[2].x - 3
		----------------------[]------------------------------------------------------
		elseif pad:square() and oldpad:square() ~= pad:square() and playerState ~= "hit" then
			blasterSound:play()
			isShooting = true
			isStanding = false
			--local sound = blasterSound
			--voice = sound:play()
			setPlayerAnimation("shoot")
			playerState = "shooting"
			bulletSetup()
			counter:start()
		-----------------------------------------------------------------------------
		elseif pad:circle() then
			Player[2].y = 0
		elseif playerState ~= "jumping" and playerState ~= "hit" and playerState ~= "shooting" and playerState ~= "falling" then
			playerState = "standing"
		end
		if playerState == "standing" and isStanding == false then
			isStanding = true
			setPlayerAnimation("stand")
		end
		screen:print(0,0,"Player state= "..playerState,white)
		--screen:print(19,29,"Enemy state= "..Enemy[currentEnemy].state,white)
		--screen:print(19,39,"Current Bullet= "..currentBullet,white)
	-----------------------------------------------------------------------------
	-- Game Over or Stage Cleared
	-----------------------------------------------------------------------------
	elseif gameState == "gameOver" or "stageClear" then
		----------------------X-----------------------------------------------------
		if pad:cross() and oldpad:cross() ~= pad:cross() then
			gameState = "titleScreen"
		end
		-----------------------------------------------------------------------------
	end
end
