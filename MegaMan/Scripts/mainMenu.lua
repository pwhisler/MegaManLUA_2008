--game start and menu images
capcom = Image.load("Images/MenusItems/capcom.PNG")
menu = Image.load("Images/MenusItems/capcom.PNG")
gameStart = Image.load("Images/MenusItems/gameStart.PNG")
continue = Image.load("Images/MenusItems/continue.PNG")
option = Image.load("Images/MenusItems/option.PNG")
gameOver = Image.load("Images/MenusItems/GameOver.PNG")
stageClear = Image.load("Images/MenusItems/stageClear1.PNG")

function menu()
	
	if gameState == "titleScreen" then
		screen:blit(58,0,capcom)
	elseif gameState == "mainMenu" then
		screen:blit(168,100,menu)
	elseif gameState == "gameStart" then
		setUp()
		screen:blit(168,100,gameStart)
		screen:print(155,235,"Start A New Game",white)
	elseif gameState == "continue" then
		screen:blit(168,100,continue)
		screen:print(155,235,"Continue A Paused Game",white)
	elseif gameState == "option" then
		screen:blit(168,100,option)
		screen:print(155,235,"Not Currently Implemented",white)
	elseif gameState == "gameOver" then
		screen:blit(75,50,gameOver)
		screen:print(160,235,"Press X To Exit",white)
	elseif gameState == "stageClear" then
		screen:blit(0,0,stageClear)
		--print out score
		screen:print(20,205,"Score     : "..score,red)
		--print out time
		screen:print(20,215,"Time      : "..levelTime.." milliseconds",red)
		--print out lives left
		screen:print(20,225,"Lives Left: "..Player[2].livesLeft,red)
		--print out directions like, press x to continue...
		screen:print(20,245,"Press X to continue...",red)
	end

end

--reset initial game variables and states
function setUp()

currentPlayer = 1
currentBullet = 1
score = 0

Player[2].health = 100
Player[2].x = 5
Player[2].y = 0
Player[2].livesLeft = 3

if stage == 1 then
	bg = Image.load("Images/Backgrounds/city1.png")
	currentEnemy = 1
	numberOfEnemies = 3
	ground = 120
	currentBG = 1
	
	Enemy[1].state = "alive"
	Enemy[1].y = ground - 30
	Enemy[1].animTable[1]:start()

	Enemy[2].state = "alive"
	Enemy[2].y = ground - 50

	Enemy[3].state = "alive"
	Enemy[3].y = ground - 25
	Enemy[3].health = 50
	
elseif stage == 2 then
	bg = Image.load("Images/Backgrounds/bg1.png")
	currentBG = 4
	currentEnemy = 1
	numberOfEnemies = 3
	Player[2].y = 0
	ground = 60
end

levelTimer:start()

end
