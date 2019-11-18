local composer = require( "composer" )

local scene = composer.newScene()

-- Physics
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Initialize variables
local score = 0
local lives = 3
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
    
    local newOrb = display.newImageRect( mainGroup, "img/purpleBall.png", 80, 80 )
    table.insert( orbsTable, newOrb )
    physics.addBody( newOrb, "dynamic", {radius=60, bounce=0.8} )
    newOrb.myName = "orb"

    local newOrb2 = display.newImageRect( mainGroup, "img/pinkBall.png", 80, 80 )
    table.insert( orbsTable, newOrb )
    physics.addBody( newOrb2, "dynamic", {radius=60, bounce=0.8} )
    newOrb2.myName = "orb"

    local newOrb3 = display.newImageRect( mainGroup, "img/weirdBall.png", 80, 80 )
    table.insert( orbsTable, newOrb )
    physics.addBody( newOrb3, "dynamic", {radius=60, bounce=0.8} )
    newOrb3.myName = "orb"

    local newOrb4 = display.newImageRect( mainGroup, "img/redBall.png", 80, 80 )
    table.insert( orbsTable, newOrb )
    physics.addBody( newOrb4, "dynamic", {radius=60, bounce=0.8} )
    newOrb4.myName = "orb"

    local newOrb5 = display.newImageRect( mainGroup, "img/blueBall.png", 80, 80 )
    table.insert( orbsTable, newOrb )
    physics.addBody( newOrb5, "dynamic", {radius=60, bounce=0.8} )
    newOrb5.myName = "orb"

    local newOrb6 = display.newImageRect( mainGroup, "img/yellowBall.png", 80, 80 )
    table.insert( orbsTable, newOrb )
    physics.addBody( newOrb6, "dynamic", {radius=60, bounce=0.8} )
    newOrb6.myName = "orb"

    local whereFrom = math.random( 1 )

        if ( whereFrom == 1 ) then
            newOrb.x = math.random( display.contentWidth + 190, display.contentWidth + 220 )
            newOrb.y = math.random( 100, display.contentHeight -130 )
            newOrb:setLinearVelocity( -1200, 0 )
            print( display.actualContentHeight )
    
            newOrb2.x = math.random( display.contentWidth + 190, display.contentWidth + 220 )
            newOrb2.y = math.random( 60, 740 )
            newOrb2:setLinearVelocity( -1000, 0 )

            newOrb3.x = math.random( display.contentWidth + 190, display.contentWidth + 220 )
            newOrb3.y = math.random( 60, 740 )
            newOrb3:setLinearVelocity( -800, 0 )

            newOrb4.x = math.random( display.contentWidth + 190, display.contentWidth + 220 )
            newOrb4.y = math.random( 60, 740 )
            newOrb4:setLinearVelocity( -600, 0 )

            newOrb5.x = math.random( display.contentWidth + 190, display.contentWidth + 220 )
            newOrb5.y = math.random( 60, 740 )
            newOrb5:setLinearVelocity( -400, 0 )

            newOrb6.x = math.random( display.contentWidth + 190, display.contentWidth + 220 )
            newOrb6.y = math.random( 60, 740 )
            newOrb6:setLinearVelocity( -200, 0 )

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
    audio.play( fireSound ) 
    local newSpell = display.newImageRect( mainGroup, "img/fireball.png", 40, 40 )
    physics.addBody( newSpell, "dynamic", {isSensor=true} )
    newSpell.isBullet = true
    newSpell.myName = "spell"
    newSpell.x = girl.x
    newSpell.y = girl.y
    newSpell:toBack()
    transition.to( newSpell, {x=1000, time=800, --1200 1600
        onComplete = function() display.remove( newSpell ) end
    } )
end

-- dragGirl()
local function dragGirl( event )
    
    local girl = event.target
    local phase = event.phase

    if ( "began" == phase ) then
        display.currentStage:setFocus( girl )
        girl.touchOffsetX = event.x - girl.x 
        girl.touchOffsetY = event.y - girl.y
    elseif ( "moved" == phase ) then
        girl.x = event.x - girl.touchOffsetX
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

--Spell's Loop
local function spellLoop()
    if ( lives == 0 ) then
        return nil
    else
        --background:addEventListener( "tap", spell )
        spell() 
    end
end

--[[
----------------------------------------------------------------------------------------------------------
-- Create display object on the screen
local newRect = display.newRect( display.contentCenterX, 160, 60, 60 )
newRect:setFillColor( 1, 0, 0.3 )

-- Touch event listener
local function touchListener( event )

    if ( event.phase == "began" ) then
        event.target.alpha = 0.5
        -- Set focus on object
        display.getCurrentStage():setFocus( event.target )

    elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
        event.target.alpha = 1
        -- Release focus on object
        display.getCurrentStage():setFocus( nil )
    end
    return true
end

-- Add a touch listener to the object
newRect:addEventListener( "tap", touchListener )
----------------------------------------------------------------------------------------------------------
--]]

-- Restore Girl
local function restoreGirl()
    girl.isBodyActive = false
    girl.x = -70
    girl.y = display.contentCenterY
    -- Fade in the girl
    transition.to( girl, {alpha=1, time=600,
        onComplete = function()
            girl.isBodyActive = true
            died = false
        end
    } )
end

-- End Game
local function endGame()
    composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", {time=800, effect="crossFade"} )
end

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
            --audio.setVolume( 0.9, {channel=1} )
            --audio.play( explosionSound )

            for i = #orbsTable, 1, -1 do
                if ( orbsTable[i] == obj1 or orbsTable[i] == obj2 ) then
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
        -- local
        background = display.newImage( backGroup, "img/background.png")
        background.x = 525
        background.y = display.contentCenterY
        background.width = 1390
        background.height = 770
        background.alpha = 0.7

-- Girl
        girl = display.newImageRect( mainGroup, "img/girl.png", 100, 110 )
        girl.x = -30
        girl.y = display.contentCenterY 
        physics.addBody( girl, {radius=30, isSensor=true} )
        girl.myName = "girl"

        background.enterFrame = scrollBackground
        Runtime:addEventListener( "enterFrame", background )

        -- Display lives and score
        livesText = display.newText( uiGroup, "Lives: " .. lives, -60, 80, native.systemFont, 36 )
        scoreText = display.newText( uiGroup, "Score: " .. score, 120, 80, native.systemFont, 36 )

        girl:addEventListener( "touch", dragGirl )

        -- explosionSound = audio.loadSound( "sounds/explosion.mp3" )
        fireSound = audio.loadSound( "sounds/fireSound.wav" )
        musicTrack = audio.loadSound( "sounds/game.mp3" )

end

-- buttons Movement
        --leftButton = display.newImageRect("img/leftdark.png", 80, 80 )
       -- leftButton.x = -50
        --leftButton.y = 600

        --rightButton = display.newImageRect( "img/rightdark.png", 80, 80 )
        --rightButton.x = 50
       -- rightButton.y = 600

      --  upButton = display.newImageRect( "img/updark.png", 80, 80 )
       -- upButton.x = 0
       -- upButton.y = 550

        --downButton = display.newImageRect( "img/downdark.png", 80, 80 )
       -- downButton.x = 0
       -- downButton.y = 650

    --musicTrack = audio.loadStream( "sounds/newland.mp3" )

-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        physics.start()
        Runtime:addEventListener( "collision", onCollision )
        gameLoopTimer = timer.performWithDelay( 700, gameLoop, 0 )
        gameSpellTimer = timer.performWithDelay( 400, spellLoop, 0 )
        audio.setVolume( 0.4, {channel=1} )
        audio.play( musickTrack, {channel=1, loops=-1} )
    end
end

-- hide()
function scene:hide( event )
    
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( gameLoopTimer )
    elseif ( phase == "did" ) then
        -- Code here runs immediateley after the scene goes entirely off screnn
        Runtime:removeEventListener( "collision", onCollision )
        physics.pause()
        audio.stop( 1 )
        composer.removeScene( "game" )
    end
end

-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removel of scene's view

    --audio.dispose( explosionSound )
    audio.dispose( fireSound )
    audio.dispose( musicTrack )
end

-- Scene event function listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene