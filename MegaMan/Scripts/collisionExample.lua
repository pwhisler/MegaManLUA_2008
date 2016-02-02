function cps() -- function by Soulkiller
	if cpsVar == nil then
		cpsVar = {
			time = Timer.new(),
			cps = 0,
			cpsprint = 0,
			boxprint = Image.createEmpty(100,8)
		}
		cpsVar.time:start()
		cpsVar.boxprint:clear(Color.new(0,0,0))
	end
	cpsVar.cps = cpsVar.cps + 1
	if cpsVar.time:time() > 1000 then
		cpsVar.cpsprint = cpsVar.cps
		cpsVar.cps = 0
		cpsVar.time:stop()
		cpsVar.time:reset()
		cpsVar.time:start()
	end
	screen:print(380,0,"CPS = "..cpsVar.cpsprint,Color.new(255,255,255))
end

function load_sprite(file)
	img = Image.load(file)
	width = img:width()
	height = img:height()
	c_map = {}
	
	-- build table with the collision map represented as a string with 1's and 0's
	for y = 0, height-1 do
		c_map[y+1] = ""
		for x = 0, width-1 do
			c = img:pixel(x,y)
			c = c:colors()
			if c.a == 0 then
				c_map[y+1] = c_map[y+1].."0"
			else
				c_map[y+1] = c_map[y+1].."1"
			end
		end
	end
	
	return {
		img = img,
		width = width,
		height = height,
		x = 0,
		y = 0,
		c_map = c_map
	}
end

function collision(obj1, obj2)
	-- first we do a basic box collsion check
	if not ((obj1.x + obj1.width > obj2.x) and (obj1.x < obj2.x + obj2.width) and (obj1.y + obj1.height > obj2.y) and (obj1.y < obj2.y + obj2.height)) then
		return false
	end
	x_offset1 = 0
	x_offset2 = 0
	y_offset1 = 0
	y_offset2 = 0
	
	-- calculate the coords and size of the overlapping area of the images
	if obj1.x > obj2.x then 
		c_x1 = obj1.x 
		x_offset1 = 1
		x_offset2 = obj1.x-obj2.x + 1
	else 
		c_x1 = obj2.x
		x_offset1 = obj2.x-obj1.x + 1
		x_offset2 = 1
	end
	
	if obj1.y > obj2.y then 
		c_y1 = obj1.y 
		y_offset1 = 1
		y_offset2 = obj1.y-obj2.y + 1
	else
		c_y1 = obj2.y 
		y_offset1 = obj2.y-obj1.y + 1
		y_offset2 = 1
	end
	
	if (obj1.x + obj1.width) > (obj2.x + obj2.width) then 
		c_x2 = (obj2.x + obj2.width)
	else
		c_x2 = (obj1.x + obj1.width) 
	end
	if (obj1.y + obj1.height) > (obj2.y + obj2.height) then 
		c_y2 = (obj2.y + obj2.height) 
	else
		c_y2 = (obj1.y + obj1.height)
	end
	
	c_w = c_x2-c_x1
	c_h = c_y2-c_y1
	
	
	-- use the coords of the overlapping areas to cut out segments of the strings in the collision map and use for pixel-perfect collision test
	for i = 0, c_h-1 do
		a = tonumber(obj1.c_map[i+y_offset1]:sub(x_offset1, x_offset1+c_w))
		b = tonumber(obj2.c_map[i+y_offset2]:sub(x_offset2, x_offset2+c_w))
		test = tostring(a + b)
		if test:match"2" then
			return true
		end
	end
	return false
end 

white=Color.new(255,255,255)
math.randomseed(os.time())

pad = Controls.read()
oldpad = pad
loop = true
	
ship = load_sprite("player.png")
ship.x = 200
ship.y = 100

ball = {}
for i = 1, 15 do
	ball[i] = load_sprite("grass.png")
	ball[i].x = math.random(20) + 150
	ball[i].y = math.random(20) + 50
end

while loop do
	screen:clear()
	pad = Controls.read()

	collisions = 0
	x = 0
	y = 0
	
	if pad:right() then x = 1 end
	if pad:left() then x = -1 end
	if pad:up() then y = -1 end
	if pad:down() then y = 1 end

	for i = 1, #ball do
		ball[i].x = ball[i].x + x
		ball[i].y = ball[i].y + y
		
		screen:blit(ball[i].x, ball[i].y, ball[i].img)
		
		if collision(ball[i], ship) then 
			collisions = collisions +1
		end
	end
	
	screen:print(10,10, "Number of active objects = "..#ball, white)
	screen:print(10,20, "Number of collisions = "..collisions, white)
	
	screen:blit(ship.x, ship.y, ship.img)
	
	cps()
	
	if pad ~= oldpad and pad:cross() then loop = false end
	oldpad = pad
	screen.flip()
end