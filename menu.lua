local composer = require( "composer" )

local scene = composer.newScene()

-- local musicTrack

local function gotoGame()
    composer.gotoScene( "game", {time=800, effect="crossFade"} )
end

local function gotoHighScores()
    composer.gotoScene( "highscores", {time=800, effect="crossFade"} )
end

-- Scene event functions

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    --Add menu background
    
    local title = display.newText( sceneGroup, "Death Bullets", display.contentCenterX, 700, native.systemFont, 100 )
    title:setFillColor( 0.82, 0.86, 1 )
    title.x = display.contentCenterX
    title.y = display.contentCenterY

    local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 700, native.systemFont, 44 )
    playButton:setFillColor( 0.82, 0.86, 1 )
    playButton.x = display.contentCenterX
    playButton.y = display.contentCenterY + 200

    local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 700, native.systemFont, 44 )
    highScoresButton:setFillColor( 0.75, 0.78, 1 )
    highScoresButton.x = display.contentCenterX
    highScoresButton.y = display.contentCenterY + 290

    playButton:addEventListener( "tap", gotoGame )
    highScoresButton:addEventListener( "tap", gotoHighScores )

    --musicTrack = audio.loadStream( "sounds/menu.mp3" )

end

-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scne is entirely on screen
        --audio.setVolume( 0.4, {channel=1} )
        --audio.play( musicTrack, {channel=1, loops=-1} )
    end
end

-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        --audio.stop( 1 )
    end
end

-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    --audio.stop( 1 )
end

-- Scene event function listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene