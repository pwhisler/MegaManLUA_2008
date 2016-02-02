-- ANIMATION LIBRARY 4 BY GRIMFATE126 --
-- 11/1/06 TO 11/9/06 --

--*******************************************--
--*			modification by Daaa			*--
--*			   v0.3, 04/20/07 				*--
--*											*--
--*	If you use this, please mention my name *--
--*	and Grimfate126 somewhere in your 		*--
--*	credits.								*--
--*											*--
--*******************************************--



ANIM = {}
ANIM_SS = {} 

ANIM.LOADED_IMAGES={} --will hold all the images shared for all the animations
--flags to tell wether speed is important (images are kept in memory) or memory is important (images are freed when not used)
ANIM.SPEED=1 --images are kept in memory until express freeing from the user
ANIM.MEMORY=2 --images are freed when there are no more references to them
ANIM.DEFAULT_MEMORY_MANAGEMENT=ANIM.MEMORY --by default, memory is important (was the case in the original animlib v4)
ANIM.TYPE_MULTIMG=3
ANIM.TYPE_SS=4

--prebuffers an image
function ANIM.bufferImage(file)
	if ANIM.LOADED_IMAGES[file]==nil then
		ANIM.LOADED_IMAGES[file]={}
		ANIM.LOADED_IMAGES[file].image=Image.load(file)
		ANIM.LOADED_IMAGES[file].ref=0
	end
	ANIM.LOADED_IMAGES[file].memory_speed=ANIM.SPEED --keep in memory
end

--frees an image if no reference on it, or mark it to be freed when no more reference on it
function ANIM.freeImage(file)
	if ANIM.LOADED_IMAGES[file]~=nil then
		ANIM.LOADED_IMAGES[file].memory_speed=ANIM.MEMORY
		if ANIM.LOADED_IMAGES[file].ref<=0 then
			ANIM.LOADED_IMAGES[file]=nil
		end
	end
end

--same as above but for all images
function ANIM.freeAllImages()
	for key, value in pairs(ANIM.LOADED_IMAGES) do
		ANIM.freeImage(key)
	end
end

--changes the default memory management to memory, so that all images are freed when not referenced
--this will apply to all next image loadings, those already in memory are not affected
function ANIM.setDefaultMemoryModeToAlwaysFree()
	ANIM.DEFAULT_MEMORY_MANAGEMENT=ANIM.MEMORY
end

--changes the default memory management to speed, so that all images are kept in memory
--this will apply to all next image loadings, those already in memory are not affected
function ANIM.setDefaultMemoryModeToBuffer()
	ANIM.DEFAULT_MEMORY_MANAGEMENT=ANIM.SPEED
end








-- creates an animation based on multiple images named sequencially (anim1.png, anim2.png etc..)
function ANIM.newMultImgAnim(nbImages, header, extension, where, delay, maxLoops)
	where = where or ""
	
	local c = setmetatable(
		{
			interval = delay,
			currentFrame = 1,
			maxFrame = nbImages, 
			loops = 1,
			frame = {},
			timer = Timer.new(),
			running=false,
			numloops=maxLoops,
--			changed=false    --tells if the image changed since last update
			lastBlitted=0
		},
	    	{
	     		__index = ANIM
	    	}
	)
	
	for load = 1, nbImages do
		local file=where..header..load.."."..extension
		if ANIM.LOADED_IMAGES[file]==nil then
			ANIM.LOADED_IMAGES[file]={}
			ANIM.LOADED_IMAGES[file].image=Image.load(file)
			ANIM.LOADED_IMAGES[file].ref=1
			ANIM.LOADED_IMAGES[file].memory_speed=ANIM.DEFAULT_MEMORY_MANAGEMENT
		else
			ANIM.LOADED_IMAGES[file].ref=ANIM.LOADED_IMAGES[file].ref+1
		end
		c.frame[load] = {}
		c.frame[load].image=ANIM.LOADED_IMAGES[file].image 
		c.frame[load].imageName=file
	end
	
	c.timer:reset()
	
	return c

end

-- creates an animation based on a spritesheet
function ANIM.newSpriteSheetAnim(file, nWidth, nHeight, delay, maxLoops)
	where = where or ""
	
	local c = setmetatable(
		{
			interval = delay,
			w = nWidth,
			h = nHeight,
			ppR = 1,	-- Pics Per Row --	
			ppC = 1,	-- Pics Per Column  --
			
			--cRow = 1,
			--cColumn = 1,
	
			currentFrame = 1,
			loops = 1,
			pic = nil,
			imageName=nil,
			timer = Timer.new(),
			running=false,
			numloops=maxLoops,
			maxFrame=nil,
			lastBlitted=0,
			
			xy={} --will contain the coords of each frame on the pic (buffers some calculations)
		},
	    	{
	     		__index = ANIM_SS
	    	}
	)
	
	
	if ANIM.LOADED_IMAGES[file]==nil then
		ANIM.LOADED_IMAGES[file]={}
		ANIM.LOADED_IMAGES[file].image=Image.load(file)
		ANIM.LOADED_IMAGES[file].ref=1
		ANIM.LOADED_IMAGES[file].memory_speed=ANIM.DEFAULT_MEMORY_MANAGEMENT
	else
		ANIM.LOADED_IMAGES[file].ref=ANIM.LOADED_IMAGES[file].ref+1
	end
	c.pic = ANIM.LOADED_IMAGES[file].image 
	c.imageName=file
	c.ppR = (c.pic:width() / c.w) 
	c.ppC = (c.pic:height() / c.h) 
	
	c.maxFrame=c.ppR * c.ppC
	
	for i = 1, c.maxFrame do
		c.xy[i]={}
		c.xy[i].x=math.mod(i-1, c.ppR) * c.w
		c.xy[i].y=math.floor((i-1)/c.ppR) * c.h
	end
	
	c.timer:reset()
	
	return c
end



-- draws the animation on the target
function ANIM:blit(target, x, y)
	target:blit(x, y, self.frame[self.currentFrame].image)
	self.lastBlitted=self.currentFrame
end
function ANIM_SS:blit(target, x, y)
	target:blit(x, y, self.pic, self.xy[self.currentFrame].x, self.xy[self.currentFrame].y, self.w, self.h) 
	self.lastBlitted=self.currentFrame
end

function ANIM:update()
	if self.running then
		self.timer:start()
		if self.numloops==nil or self.loops <= self.numloops then
			if self.timer:time() > self.interval then
				self.currentFrame = self.currentFrame + 1
				self.timer:reset()
			end 
	
			if self.currentFrame > self.maxFrame then
				self.loops = self.loops + 1
				if self.numloops==nil or self.loops <= self.numloops then
					self.currentFrame = 1
				else
					self.currentFrame=self.maxFrame
					self.timer:reset()
					self.loops = self.numloops
					self.running=false
				end
			end 
		end
	end
end
function ANIM_SS:update()
	if self.running then
		self.timer:start()
		if self.numloops==nil or self.loops <= self.numloops then
			-- Loop --
			if self.timer:time() >= self.interval then
				self.currentFrame = self.currentFrame + 1
				self.timer:reset()
			end
		
			if self.currentFrame > self.maxFrame then
				self.loops = self.loops + 1
				if self.numloops==nil or self.loops <= self.numloops then
					self.currentFrame = 1
				else
					self.currentFrame=self.maxFrame
					self.timer:reset()
					self.loops = self.numloops
					self.running=false
				end
			end 
		end
	end
end

--since last blit! not since last update!!
function ANIM:frameChanged()
	return self.lastBlitted~=self.currentFrame
end
function ANIM_SS:frameChanged()
	return self.lastBlitted~=self.currentFrame
end


function ANIM:width()
	return self.frame[self.currentFrame].image:width()
end
function ANIM_SS:width()
	return self.w
end

function ANIM:height()
	return self.frame[self.currentFrame].image:height()
end
function ANIM_SS:height()
	return self.h
end




-- get the numth image, very inefficient with spritesheets
function ANIM:getImage(num)
	num=num or 1
	num=math.mod(num-1, self.maxFrame)+1
	return self.frame[num].image
end
function ANIM_SS:getImage(num)
	if num==nil then
		return self.pic
	end
	
	-- else
	num=math.mod(num-1, self.ppC*self.ppR)+1
		
	local img=Image.createEmpty(self.w, self.h)
	img:blit(0, 0, self.pic, self.xy[num].x, self.xy[num].y, self.w, self.h)
	return img
end




--resets the animation to the frame number "num", or the first if no arg is supplied
--do not use with negative numbers or 0
function ANIM:reset(num)
	num = num or 1
	num=math.mod(num-1, self.maxFrame)+1
	self.currentFrame = num
end
function ANIM_SS:reset(num)
	num = num or 1
	num=math.mod(num-1, self.ppC*self.ppR)+1
	self.currentFrame = num
end




-- pauses the animation
function ANIM:pause()
	self.timer:stop()
	self.running=false
end
function ANIM_SS:pause()
	self.timer:stop()
	self.running=false
end





-- resumes the animation
function ANIM:resume()
	self.timer:start()
	self.running=true
end
function ANIM_SS:resume()
	self.timer:start()
	self.running=true
end




-- starts the animation. if it's already started, it restarts
-- loops number are restarted
function ANIM:start()
	self:reset()
	self.timer:start()
	self.running=true
	self.loops=1
end
function ANIM_SS:start()
	self:reset()
	self.timer:start()
	self.running=true
	self.loops=1
end





-- frees the animation, ie the object, and also the images if they are not referenced from another
-- animation and the memory management for them favors memory over speed.
-- if speed is favored, even when there are no more references on them they stay in memory,
-- and you have to free them with ANIM.freeImage(file)
function ANIM:free()
	local f
	
	for f = 1, self.maxFrame do
		ANIM.LOADED_IMAGES[self.frame[f].imageName].ref=ANIM.LOADED_IMAGES[self.frame[f].imageName].ref-1
		if ANIM.LOADED_IMAGES[self.frame[f].imageName].ref==0 and ANIM.LOADED_IMAGES[self.frame[f].imageName].memory_speed==ANIM.MEMORY then
			ANIM.LOADED_IMAGES[self.frame[f].imageName].image=nil
			ANIM.LOADED_IMAGES[self.frame[f].imageName]=nil
		end
		self.frame[f].image = nil
	end
	
	self=nil
end
function ANIM_SS:free()
	ANIM.LOADED_IMAGES[self.imageName].ref=ANIM.LOADED_IMAGES[self.imageName].ref-1
	if ANIM.LOADED_IMAGES[self.imageName].ref==0 and ANIM.LOADED_IMAGES[self.imageName].memory_speed==ANIM.MEMORY then
		ANIM.LOADED_IMAGES[self.imageName].image=nil
		ANIM.LOADED_IMAGES[self.imageName]=nil
	end

	self.pic = nil
	self=nil
end





-- tells if it's running
function ANIM:isRunning()
	return self.running
end
function ANIM_SS:isRunning()
	return self.running
end





-- the contrary of isRunning()
function ANIM:isPaused()
	return not self.running
end
function ANIM_SS:isPaused()
	return not self.running
end




-- tells if it has made n loops already
-- this is true if it has made more, or if it has reached the last frame of the nth loop
function ANIM:finishedLooping(n)
	if self.loops<n then
		return false
	end
	
	if self.loops>n then
		return true
	end
	
	--here, self.loops==n
	if self.currentFrame==self.maxFrame then
		return true --we are on the last frame, so yes, it's over
	end

	return false
end
function ANIM_SS:finishedLooping(n)
	if self.loops<n then
		return false
	end
	
	if self.loops>n then
		return true
	end
	
	--here, self.loops==n
	if self.currentFrame==self.maxFrame then
		return true --we are on the last frame, so yes, it's over
	end
	
	return false
end




-- sets the delay between frames
function ANIM:setDelay(delay)
	self.interval = delay
end
function ANIM_SS:setDelay(delay)
	self.interval = delay
end




-- resets the loop counter to 1
function ANIM:resetLoop()
	self.loops = 1
end
function ANIM_SS:resetLoop()
	self.loops = 1
end





-- returns the current timer time
function ANIM:getTime()
	return self.timer:time()
end
function ANIM_SS:getTime()
	return self.timer:time()
end





-- returns the current frame
function ANIM:getFrame()
	return self.currentFrame
end
function ANIM_SS:getFrame() 
	return self.currentFrame
end





-- returns the current loop number
function ANIM:getLoops()
	return self.loops
end
function ANIM_SS:getLoops()
	return self.loops
end



-- returns the current row, might be useful for spritesheet animations
-- always returns 1 for multiple images animations
function ANIM:getRow()
	return 1
end
function ANIM_SS:getRow()
	return math.floor((self.currentFrame-1)/self.ppR) + 1
end --TODO: maybe buffer this too? shouldn't be used too often so it's better like this



-- returns the current column, might be useful for spritesheet animations
-- always returns 1 for multiple images animations
function ANIM:getColumn()
	return 1
end
function ANIM_SS:getColumn()
	return math.mod(self.currentFrame-1, self.ppR) + 1
end --TODO: maybe buffer this too



-- utility function to add a property (can be a table of properties)
function ANIM:setProp(prop)
	self.prop=prop
end
function ANIM_SS:setProp(prop)
	self.prop=prop
end





-- gets the property or properties table
function ANIM:getProp()
	return self.prop
end
function ANIM_SS:getProp()
	return self.prop
end



-- returns what type of animation it is, multimg or ss
function ANIM:getType()
	return ANIM.TYPE_MULTIMG
end
function ANIM_SS:getType()
	return ANIM.TYPE_SS
end



-- returns the limit of loops it's autorized to do.
-- nil means no limit
function ANIM:getMaxLoops()
	return self.numloops
end
function ANIM_SS:getMaxLoops()
	return self.numloops
end



-- sets the limit of loops it's autorized to do.
-- nil means no limit
function ANIM:setMaxLoops(maxLoops)
	self.numloops=maxLoops
end
function ANIM_SS:setMaxLoops(maxLoops)
	self.numloops=maxLoops
end



-- returns the number of pictures used for this anim
function ANIM:getNbPictures()
	return self.maxFrame
end
function ANIM_SS:getNbPictures()
	return 1
end


-- returns the frame number this anim is composed of
function ANIM:getNbFrames()
	return self.maxFrame
end
function ANIM_SS:getNbFrames()
	return self.maxFrame
end



-- returns the name of the numth image
function ANIM:getImageName(num)
	num = num or 1
	num=math.mod(num-1, self.maxFrame)+1
	return self.frame[num].imageName
end
function ANIM_SS:getImageName(num)
	return self.imageName
end


-- calls freeImage on each image used in this anim
function ANIM:unbufferImages()
	for i=1, self.maxFrame do
		ANIM.freeImage(self.frame[i].imageName)
	end
end
function ANIM_SS:unbufferImages()
	ANIM.freeImage(self.imageName)
end


--untested
function ANIM:pixel(x, y)
	return self.frame[currentFrame].image:pixel(x, y)
end
function ANIM_SS:pixel(x, y)
	return self.pic:pixel(self.xy[currentFrame].x + x, self.xy[currentFrame].y + y)
end

--untested
function ANIM:save(filename)
	return self.frame[currentFrame].image:save(filename)
end
function ANIM_SS:save(filename)
	local img=Image.createEmpty(self.w, self.h)
	img:blit(0, 0, self.pic, self.xy[currentFrame].x, self.xy[currentFrame].y, self.w, self.h)
	return img:save(filename)
end






