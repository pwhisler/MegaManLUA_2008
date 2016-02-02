--PSP SCREEN is 480 x 272 PIXELS--
--********Variables*********--
green = Color.new(0,255,0)
red = Color.new(255,0,0)
blue = Color.new(0,0,255)
white = Color.new(255,255,255)
mysteryColor = Color.new(155,25,95)
velocity = 15
acceleration = -1
ground = 120
currentBG = 1
counter = Timer.new()
counter:start()
counter:stop()
stage = 1

levelTimer = Timer.new()
levelTimer:start()

currentBullet = 0
direction = "right"

gameState = "titleScreen"
score = 0
--*************************--
-- Create our bullet
bullet = Image.load("Images/MegaMan/Projectile/blast.PNG")
--...for collision
bull = load_sprite("Images/MegaMan/Projectile/blast.PNG")

Player = {}
Player[2]={x = 0, y = 0, dir = "right", health = 100, weapon = "ArmBlaster", power = 100, livesLeft = 3, animTable={}}
Player[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/MegaMan/Stance/stand.PNG", 33,51,50)
Player[2].animTable[1]:start()

-- Create Array for Bullets
BulletInfo = {}
for a = 1,3 do
	BulletInfo[a] = { pic = bullet , firing = false, direction = Player[2].dir, x = Player[2].x + 32, y = Player[2].y - 10  }
end

--images for how many lifes player has left, drawn to the screen
lives = Image.load("Images/MenusItems/livesIcon.png")

-- enemy data
Enemy ={}
Enemy[1]={x = 220, y = ground-30, type = "flyBot", state = "alive", health = 10, power = 10, dir = "", animTable={}}
Enemy[1].animTable[1]=ANIM.newSpriteSheetAnim("Images/Enemy1/Fly/fly.png", 33.75,40,50)
Enemy[1].animTable[1]:start()
----
Enemy[2]={x = 270, y = ground-50, type = "flyBot", state = "alive", health = 10, power = 10, dir = "", animTable={}}
Enemy[2].animTable[1]=ANIM.newSpriteSheetAnim("Images/Enemy1/Fly/fly.png", 33.75,40,50)
Enemy[2].animTable[1]:start()
----		
Enemy[3]={x = 380, y = ground-25, type = "fatBot", state = "alive", health = 50, power = 10, dir = "", animTable={}}
Enemy[3].animTable[1]=ANIM.newSpriteSheetAnim("Images/Enemy2/Shoot/Shoot.png", 79.1,88,150)
Enemy[3].animTable[1]:start()
----
Enemy[10]={x = Enemy[3].x, y = ground, type = "orb", state = "alive", dir = "Left", animTable={}}
Enemy[10].animTable[1]=ANIM.newSpriteSheetAnim("Images/Enemy2/Projectile/ball3.png", 64,62,100)
Enemy[10].animTable[1]:start()
orb = load_sprite("Images/Enemy2/Projectile/ballCollision.png")
----

currentEnemy = 1
currentPlayer = 1
currentBullet = 0

--increase this each time you add an enemy!!
numberOfEnemies = 3

--sounds
blasterSound = Sound.load("Audio/blaster.wav",false)
jumpSound = Sound.load("Audio/jump.wav",false)
megaManDeadSound = Sound.load("Audio/megaManDead.wav",false)
hitSound = Sound.load("Audio/hit.wav",false)
enemyHitSound = Sound.load("Audio/enemyHit.wav",false)
bossDiedSound = Sound.load("Audio/bossDied.wav",false)

--images
bg = Image.load("Images/Backgrounds/city1.png")
--bg = Image.load("Images/Backgrounds/bg1.png")
healthBar = Image.load("Images/MenusItems/healthBar.png")
health = Image.load("Images/MenusItems/health.png")
statsHolder = Image.load("Images/MenusItems/statsHolder.png")
playerState = "standing"
setPlayerAnimation("stand")
setEnemyAnimation("alive",currentEnemy)

grd = load_sprite("Images/CollisionMaps/floor2.png")
groundImage = Image.load("Images/CollisionMaps/floor2.png")
grd1 = load_sprite("Images/CollisionMaps/piece1.png")
groundImage1 = Image.load("Images/CollisionMaps/piece1.png")
grd2 = load_sprite("Images/CollisionMaps/piece2.png")
groundImage2 = Image.load("Images/CollisionMaps/piece2.png")
grd3 = load_sprite("Images/CollisionMaps/piece3.png")
groundImage3 = Image.load("Images/CollisionMaps/piece3.png")
grd4 = load_sprite("Images/CollisionMaps/piece4.png")
groundImage4 = Image.load("Images/CollisionMaps/piece4.png")
grd5 = load_sprite("Images/CollisionMaps/piece2.png")
groundImage5 = Image.load("Images/CollisionMaps/piece2.png")
grd6 = load_sprite("Images/CollisionMaps/piece4.png")
groundImage6 = Image.load("Images/CollisionMaps/piece4.png")
grd7 = load_sprite("Images/CollisionMaps/piece2.png")
groundImage7 = Image.load("Images/CollisionMaps/piece2.png")
grd8 = load_sprite("Images/CollisionMaps/piece4.png")
groundImage8 = Image.load("Images/CollisionMaps/piece4.png")
grd9 = load_sprite("Images/CollisionMaps/piece1.png")
groundImage9 = Image.load("Images/CollisionMaps/piece1.png")

grd1.x = 12
grd1.y = 134
grd2.x = 75
grd2.y = 115
grd3.x = 85
grd3.y = 112
grd4.x = 151
grd4.y = 147
grd5.x = 138
grd5.y = 120
grd6.x = 237
grd6.y = 131
grd7.x = 284
grd7.y = 119
grd8.x = 294
grd8.y = 113
grd9.x = 407
grd9.y = 162

--for moving the enemy3's projectile
newX = Enemy[3].x
--***************************************************************************--