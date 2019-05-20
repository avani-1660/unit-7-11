-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Hides status bar
display.setStatusBar(display.HiddenStatusBar)

-- Gets physics
local physics = require( "physics" )

-- Starts physics and sets gravity and hilights the sprites with physics
-----------------
physics.start()
physics.setGravity( 0, 10 ) -- ( x, y )
--physics.setDrawMode( "hybrid" )
----------------


local theGround = display.newImageRect( "assets/land.png", 600,150)
theGround.x = 240
theGround.y = 450
theGround.id = "the ground"
physics.addBody( theGround, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local jumpButton = display.newImageRect( "assets/jumpButton.png", 75,75)
jumpButton.x = 240
jumpButton.y =450
jumpButton.id = " jumpButton"
--------------------

--Knight character
------------------------------------------------------------------------- 

-- Sets the sheet height and width for the knight standing.
local sheetOptionsIdle =
{
    width = 587,
    height = 707,
    numFrames = 10
}

-- Gets knight standing sheet
local sheetIdleKnight = graphics.newImageSheet( "assets/knightIdle.png",  sheetOptionsIdle )

-- Sets the sheet height and width for the knight walking.
local sheetOptionsWalk =
{
    width = 587,
    height = 707,
    numFrames = 10
}

-- Gets knight walking sheet
local sheetWalkingKnight = graphics.newImageSheet( "assets/knightWalking.png", sheetOptionsWalk )

-- Sets the sheet height and width for the knight dying.
local sheetOptionsDead =
{
    width = 944,
    height = 751,
    numFrames = 10
}

-- Gets knight dying sheet
local sheetDeadKnight = graphics.newImageSheet( "assets/knightDead.png",  sheetOptionsDead )


-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetIdleKnight
    },
    {
        name = "walk",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetWalkingKnight
    },
        {
        name = "dead",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetDeadKnight
    }

}

-- Scroll speed for the knight
kscrollspeed = 0.75

-- Gets knight standing from knight standing sheet
----------------------
local knight = display.newSprite( sheetIdleKnight, sequence_data )
knight.x = 120
knight.y = 160
knight.xScale = 140/587
knight.yScale = 200/707
knight.width = 110
knight.height = 180
knight.id = "knight"
---------------------
-- Physics for the knight
physics.addBody( knight, "dynamic", { 
    density = 3.0, 
    friction = 0, 
    bounce = 0 
    } )

knight:play() 

local sheetOptionsIdle =
{
    width = 232,
    height = 439,
    numFrames = 10
}

-- Gets ninja standing sheet
local sheetIdleNinja = graphics.newImageSheet( "assets/ninjaBoyIdle.png",  sheetOptionsIdle )

-- Sets the sheet height and width for the ninja throwing action.
local sheetOptionsThrow =
{
    width = 377,
    height = 451,
    numFrames = 10
}

-- Gets ninja throwing sheet
local sheetThrowNinja = graphics.newImageSheet( "assets/ninjaBoyThrow.png", sheetOptionsThrow )

-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetIdleNinja
    },
    {
        name = "throw",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetThrowNinja
    }
}

-- Scroll speed for the ninja
scrollspeed = 1.5

-- Gets ninja standing from ninja standing sheet
---------------------------
local ninja = display.newSprite( sheetIdleNinja, sequence_data )
ninja.x = 20
ninja.y = 160
ninja.xScale = 120/377
ninja.yScale = 180/451
ninja.width = 100
ninja.height = 180
ninja.id = "ninja"
-- Physics for the ninja
physics.addBody( ninja, "dynamic", { 
    density = 3.0, 
    friction = 0, 
    bounce = 0 
    } )
-- Plays ninja animation
ninja:play()
---------------------------

-- After a short time, swap the sequence to 'seq2' which uses the second image sheet
local function swapSheet()
    knight:setSequence( "walk" )
    knight:play()
    print("walk")
end

-- Knight autmatically moves after a 2 seconds
-----------------------
local function moveKnight( event )
    timer.performWithDelay(2000, function()
        knight.x = knight.x + kscrollspeed
    end
    )
end
-----------------------

local function ninjaswap (event)
    if ( event.phase == "began" ) then
    -- make a bullet appear
        kunai = display.newImageRect( "assets/Kunai.png", 60, 20 )
        kunai.x = ninja.x
        kunai.y = ninja.y
        physics.addBody( kunai, 'dynamic' )
        -- Make the object a "bullet" type object
        kunai.isBullet = true
        kunai.isFixedRotation = true
        kunai.gravityScale = 0
        kunai.id = "bullet"
        kunai:setLinearVelocity( 500, 0 )

        -- Does ninja throwing animation
        ----------------------
        ninja:setSequence( "throw" )
        ninja:play()
        print("throw")
        ----------------------

        -- Makes ninja stand by playing idle animation after less than a second
        ---------------------
        timer.performWithDelay(800, function()
            ninja:setSequence( "idle" )
            ninja:play()
        ---------------------
        end
        )
    end
    
    return true
end

-- Collision detection function
-------------------------------
local function onCollision( event )
    
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
        local whereCollisonOccurredX = obj1.x
        local whereCollisonOccurredY = obj1.y

        if ( ( obj1.id == "knight" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "knight" ) ) then
            -- Removes kunai 
            kunai:removeSelf()

            -- Plays knight dying animation
            knight:setSequence( "dead" )
            knight:play()
            print("dead")

            -- Resets scroll speed for knight
            kscrollspeed = 0

            timer.performWithDelay(780, function()
                knight:pause()
            end
            )
        end
    end
end
-------------------------------

-- Event listeners
jumpButton:addEventListener("touch", ninjaswap )
timer.performWithDelay( 2000, swapSheet )
Runtime:addEventListener("enterFrame", moveKnight )
Runtime:addEventListener( "collision", onCollision )
