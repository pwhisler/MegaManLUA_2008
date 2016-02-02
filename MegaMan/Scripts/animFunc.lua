dofile("./Scripts/collision.lua")
--==========================================================================================================
function setPlayerAnimation(state)
	-- destroy the animation
	--Player[2].animTable[1]:unbufferImages()
	--Player[2].animTable[1]:free()
	
	--System.getFreeMemory()
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	if state == "walk" then
		if Player[2].dir == "right" then
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Run/runRight.png", 49.6,48,50)
		else
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Run/runLeft.png", 49.6,48,50)
		end
		Player[2].animTable[1]:start()
		ply = load_sprite("Images/MegaMan/Run/runCol.png")
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	elseif state == "stand" then
		
		if Player[2].dir == "right" then
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Stance/stand.PNG", 49.25,45,150)
		else
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Stance/standLeft.PNG", 49.25,45,150)
		end
		Player[2].animTable[1]:start()
		ply = load_sprite("Images/MegaMan/Stance/standCol.PNG")
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++		
	elseif state == "jump" then
		if Player[2].dir == "right" then
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Jump/jump.png", 49.75,72,75)
		else
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Jump/jumpLeft.png", 49.75,72,75)
		end
		
		Player[2].animTable[1]:start()
		ply = load_sprite("Images/MegaMan/Jump/jumpCol.png")
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++		
	elseif state == "shoot" then
		if Player[2].dir == "right" then
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Shoot/shoot.png", 50,46,50,1)
			bullet = Image.load("Images/MegaMan/Projectile/blast.PNG")
		else
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Shoot/shootLeft.png", 50,46,50,1)
			bullet = Image.load("Images/MegaMan/Projectile/blastLeft.PNG")
		end
		for a = 1,3 do
			BulletInfo[a].pic = bullet
		end
		Player[2].animTable[1]:start()
		ply = load_sprite("Images/MegaMan/Jump/jumpCol.png")
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++		
	elseif state == "hit" then
		if Player[2].dir == "right" then
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Hit/hit.png", 49,51,500,1)
		else
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Hit/hitLeft.png", 49,51,500,1)
		end
		Player[2].animTable[1]:start()
		ply = load_sprite("Images/MegaMan/Jump/jumpCol.png")
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++		
	elseif state == "dead" then
		if Player[2].dir == "right" then
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Die/Die.png", 51,53,500,1)
		else
			Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Die/DieLeft.png", 51,53,500,1)
		end
		Player[2].animTable[1]:start()
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++		
	end
end
--==========================================================================================================
function setEnemyAnimation(state, enemyNum)
	if state == "alive" and enemyNum == 1  then
		--Enemy[1].animFrames[1]=ANIM.newMultImgAnim(15, "enemy1_", "png", "Images/Enemy1/", 100)
		--Enemy[1].animFrames[1]:start()
		Enemy[1].animTable[1]=ANIM.newSpriteSheetAnim("Images/Enemy1/Fly/fly.png", 32,40,50)
		Enemy[1].animTable[1]:start()
		emy = load_sprite("Images/Enemy1/Fly/collision.png")
	elseif state == "alive" and enemyNum == 2 then
		Enemy[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/Enemy1/Fly/fly.png", 32,40,50)
		Enemy[2].animTable[1]:start()
		emy = load_sprite("Images/Enemy1/Fly/collision.png")
	elseif state == "alive" and enemyNum == 3 then
		Enemy[3].animTable[1]=ANIM.newSpriteSheetAnim("Images/Enemy2/Shoot/Shoot.png", 90,63,350)
		Enemy[3].animTable[1]:start()
		emy = load_sprite("Images/Enemy2/Punch/collision.png")
--[[	elseif state == "right" and enemyNum == 3 then
		Enemy[3].animTable[1]=ANIM.newSpriteSheetAnim("Images/Enemy2/Punch/punch.png", 79.1,88,150)
		Enemy[3].animTable[1]:start()
		emy = load_sprite("Images/Enemy2/Punch/collision.png")
	elseif state == "left" and enemyNum == 3 then
		Enemy[3].animTable[1]=ANIM.newSpriteSheetAnim("Images/Enemy2/Shoot/Shoot.png", 79.1,88,150)
		Enemy[3].animTable[1]:start()
		emy = load_sprite("Images/Enemy2/Punch/collision.png")   --]]
	end
	
end
--==========================================================================================================
--my own wait function so i don't have to always create timers and stuff...
function wait(waitTime)
	waitCounter = Timer.new()
	waitCounter:start()
	timeWaited = waitCounter:time()
	
	--loop until waited the amount of time passed in, and then stop the timer
	--while timeWaited < waitTime do
		
	--end
	--waitCounter:stop()
	
end
--==========================================================================================================
--==========================================================================================================
--==========================================================================================================
--==========================================================================================================
--==========================================================================================================
--==========================================================================================================