local composer = require( "composer" )

local scene = composer.newScene()

local musicTrack

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

    -- Menu Background
    local menuBackground = display.newImage( sceneGroup, "img/background.png")
    menuBackground.x = 525
    menuBackground.y = display.contentCenterY
    menuBackground.width = 1390
    menuBackground.height = 770
    
    local title = display.newText( sceneGroup, "Death Bullets", display.contentCenterX, 700, "fonts/blackchancery", 130 )
    --title:setFillColor( 0.82, 0.86, 1 )
    --title:setFillColor( 0.686, 0.388, 0.811 )
    --title:setFillColor( 0.650, 0.321, 0.898 ) 
    title:setFillColor( 0.627, 0.584, 0.839 ) 
    title.x = display.contentCenterX
    title.y = display.contentCenterY - 30

    -- Play
    local playButton = display.newImageRect( sceneGroup, "img/play.png", 100, 100 )
    playButton.x = display.contentCenterX - 240
    playButton.y = display.contentCenterY + 220

    local playText = display.newText( sceneGroup, "Play", display.contentCenterX, 700, "fonts/blackchancery", 44 )
    playText:setFillColor( 1, 1, 1 )
    playText.x = playButton.x + 120
    playText.y = playButton.y

    -- Scores
    local highScoresButton = display.newImageRect( sceneGroup, "img/scores.png", 100, 100 )
    highScoresButton.x = display.contentCenterX + 80
    highScoresButton.y = display.contentCenterY + 220
    
    local highScoresText = display.newText( sceneGroup, "Scores", display.contentCenterX, 700, "fonts/blackchancery", 44 )
    highScoresText:setFillColor( 1, 1, 1 )
    highScoresText.x = highScoresButton.x + 147
    highScoresText.y = highScoresButton.y

    playButton:addEventListener( "tap", gotoGame )
    playText:addEventListener( "tap", gotoGame )
    highScoresButton:addEventListener( "tap", gotoHighScores )
    highScoresText:addEventListener( "tap", gotoHighScores )

    musicTrack = audio.loadStream( "sounds/windsOfStoriesSound.mp3" )

end

-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scne is entirely on screen
        audio.setVolume( 0.4, {channel=1} )
        audio.play( musicTrack, {channel=1, loops=-1} )
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
        audio.stop( 1 )
    end
end

-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    audio.stop( 1 )
end

-- Scene event function listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene