--==========================================================================================================
function enemyMovement(enemy)
	if enemy == 1 then --fly bot-----------------------------------------------------------------
		if Enemy[enemy].x > 300 then
			Enemy[enemy].dir = "left"
		elseif Enemy[enemy].x < 100 then
			Enemy[enemy].dir = "right"
		end
		if Enemy[enemy].dir == "right" then
			Enemy[enemy].x = Enemy[enemy].x + 1
		else 
			Enemy[enemy].x = Enemy[enemy].x - 1
		end
	elseif enemy == 2 then --fly bot 2-----------------------------------------------------------------
		if Enemy[enemy].y < 10 then
			Enemy[enemy].dir = "down"
		elseif Enemy[enemy].y > 100 then
			Enemy[enemy].dir = "up"
		end
		if Enemy[enemy].dir == "down" then
			Enemy[enemy].y = Enemy[enemy].y + 1
		else 
			Enemy[enemy].y = Enemy[enemy].y - 1
		end
	end

	emy.x = Enemy[enemy].x
	emy.y = Enemy[enemy].y
end
--==========================================================================================================
function dealDamage()
	--if enemy is hit, minus their health and check if they are dead
	Enemy[currentEnemy].health = Enemy[currentEnemy].health - 10
	if Enemy[currentEnemy].health <= 0 then
		Enemy[currentEnemy].state = "dead"
		Enemy[currentEnemy].animTable[1]:pause()
		if currentEnemy == 3 then
			bossDiedSound:play()
			orb.y = 1000
			score = score + 2000
		end
	else
		Enemy[currentEnemy].state = "alive"
	end
end
--==========================================================================================================

--==========================================================================================================