-- Physics
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Initialize variables
local score = 0
local lives = 1
local died = false
local orbsTable = {}
local gameLoopTimer
local scoreText
local livesText

local backGroup
local mainGroup
local uiGroup
local sceneGroup

local explosionSound
local fireSound
local musicTrack

-- Seed the random number generator
math.randomseed( os.time() )

-- Set up display groups
local backGroup = display.newGroup()
local mainGroup = display.newGroup()

-- Background
local background = display.newImage( backGroup, "img/background.png")
background.x = 525
background.y = display.contentCenterY
background.width = 1390
background.height = 770
background.alpha = 0.8

-- Girl
local girl = display.newImageRect( mainGroup, "img/girl.png", 100, 110 )
girl.x = -30
girl.y = display.contentCenterY 
physics.addBody( girl, {radius=30, isSensor=true} )
girl.myName = "girl"

-- Orbs
local function createOrb()
    local newOrb = display.newImageRect( mainGroup, "img/purpleBall", 120, 140 )
    table.insert( orbsTable, newOrb )
    physics.addBody( newOrb, "dynamic", {radius=60, bounce=0.8} )
    newOrb.myName = "orb"

    local whereFrom = math.random( 1 )

    if (whereFrom == 1) then
        newOrb.x = math.random( display.contentWidth + 190, display.contentWidth + 220 )
        newOrb.y = math.random( 100, display.contentHeight -130 )
        newOrb:setLinearVelocity( -300, 0 )
        print( display.actualContenntHeight )
    
        newOrb2.x = math.random( display.contentWidth + 190, display.contentWidth + 220 )
        newOrb2.y = math.random( 60, 740 )
        newOrb2:setLinearVelocity( -300, 0 )

    --[[
        elseif ( whereFrom == 2 ) then
        -- From the top
        newOrb.x = math.random( display.contentWidth )
        newOrb.y = -60
        newOrb:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    --]]
     
    end

end

-- Spell
local function spell()
    local newSpell = display.newImageRect( mainGroup, "img/spell.png", 30, 20 )
    physics.addBody( newSpell, "dynamic", {isSensor=true} )
    newSpell.isBullet = true
    newSpell.myName = "spell"
    newSpell.x = girl.x
    newSpell.y = girl.y
    newSpell:toBack()
    transition.to( newSpell, {x=1200, time=1600,
        onComplete = function() display.remove( newLaser ) end
    } )
end

-- Girl's Movement
local function dragGirl( event )
    
    local girl = event.target
    local phase = event.phase

    if ( "began" == phase ) then
        display.currentStage:setFocus( girl )
        girl.touchOffsetY = event.y - girl.y
    elseif ( "moved" == phase ) then
        girl.y = event.y - girl.touchOffsetY
    elseif ( "ended" == phase or "cancelled" == phase ) then
        display.currentStage:setFocus( nil )
    end

    return true -- Prevents touch propagation to underlying objects

end

-- Call create Orbs
local function gameLoop()
    createOrb()
end

-- Spell's Loop
local function spellLoop()
    if ( lives == 0 ) then
        return nil
    else
        spell()
    end
end

-- Restore Girl
local function restoreGirl()
    girl.isBodyActive = false
    girl.x = -70
    girl.y = display.contentCenterY
    -- Fade in the girl
    transition.to( girl, {alpha=1, time=800,
        onComplete = function()
            girl.isBodyActive = true
            died = false
        end
    } )
end

-- End Game

-- Collison