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

-- Texts
local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

-- Orbs
local function createOrb()
    local newOrb = display.newImageRect( mainGroup, "img/purpleBall", 120, 140 )
    table.insert( orbsTable, newOrb )
    physics.addBody( newOrb, "dynamic", {radius=60, bounce=0.8} )
    newOrb.myName = "orb"

    local newOrb2 = display.newImageRect( mainGroup, "img/purpleBall", 120, 150 )
    table.insert( orbsTable, newOrb )
    physics.addBody( newOrb2, "dynamic", {radius=60, bounce=0.8} )
    newOrb2.myName = "orb"

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
    -- audio.play( fireSound ) 
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
--[[
local function endGame()
    composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", {time=800, effect="crossFade"} )
--]]

-- Collison
local function onCollision( event )
    
    if ( event.phase == "began" ) then

        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "spell" and obj2.myName == "orb" ) or
            ( obj1.myName == "orb" and obj2.myName == "spell" )  or
            ( obj1.myName == "spell" and obj2.myName == "orb2" ) or
            ( obj1.myName == "orb2" and obj2.myName == "spell" ) )
        then
            obj1 = display.newImageRect( mainGroup, "img/explosion.png", 100, 100 )
            display.remove( obj1 )
            display.remove( obj2 )
            -- audio.setVolume( 0.9, {channel=1} )
            -- audio.play( explosionSound )

            for i = #orbsTable, 1, -1 do
                if ( orbsTable[1] == obj1 or orbsTable[i] == obj2 ) then
                    table.remove( orbsTable, i )
                    break
                end
            end
            -- Increase score
            score = score + 100
            scoreText.text = "Score: " .. score
    
        elseif ( ( obj1.myName == "girl" and obj2.myName == "orb") or
                 ( obj1.myName == "orb"  and obj2.myName == "girl") -- or
             --  ( obj1.myName == "girl" and obj2.myName == "LaserEnemy") or
             --  ( obj1.myName == "LaserEnemy" and obj2.myName == "girl" )
                )
        then
            if ( died == false ) then
                died = true

            -- audio.play( explosionSound )

                -- Update lives
                lives = lives - 1
                livesText.text = "Lives: " .. lives

                if ( lives == 0 ) then
                    display.remove( girl )
                    timer.performWithDelay( 1000, endGame )
                else
                    girl.alpha = 0
                    timer.performWithDelay( 1000, restoreGirl )
                end
            end
        end
    end
end

-- Scene event functions

-- create()
function scene:create( event )
    
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.pause() -- Temporarily pause the physics engine

    -- Set up display groups
    backGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group

    mainGroup = display.newGroup()  -- Display group for the girl, orbs, spell, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

-- Background
    local background = display.newImage( backGroup, "img/background.png")
        background.x = 525
        background.y = display.contentCenterY
        background.width = 1390
        background.height = 770
        background.alpha = 0.8

-- Girl
        girl = display.newImageRect( mainGroup, "img/girl.png", 100, 110 )
        girl.x = -30
        girl.y = display.contentCenterY 
        physics.addBody( girl, {radius=30, isSensor=true} )
        girl.myName = "girl"

        background.enterFrame = scrollBackground
        Runtime:addEventListener( "enterFrame", background )

        -- Display lives and score
        livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
        scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )

        girl:addEventListener( "touch", dragGirl )

        -- explosionSound = audio.loadSound( "sounds/explosion.mp3" )
        -- fireSound = audio.loadSound( "sounds/spell.wav" )
        -- musicTrack = audio.loadSound( "sounds/ingame.mp3" )

end
