local composer = require( "composer" )

local scene = composer.newScene()

-- Initialize variables

local json = require( "json" )

local scoresTable = {}

local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

-- Load scores
local function loadScores()

    local file = io.open( filePath, "r" )

    if file then
        local contents = file:read( "*a" )
        io.close( file )
        scoresTable = json.decode( contents )
    end

    --scoresTable = {0, 0, 0, 0, 0}

    if ( scoresTable == nil or #scoresTable == 0 ) then
        scoresTable = {0, 0, 0, 0, 0}
    end
end

-- Save scores
local function saveScores()

    for i = #scoresTable, 11, -1 do
        table.remove( scoresTable, i )
    end

    local file = io.open( filePath, "w" )

    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end

-- Go to
local function gotoMenu()
    composer.gotoScene( "menu", {time=800, effect="crossFade"} )
end

local function gotoGame()
    composer.gotoScene( "game", {time=800, effect="crossFade"} )
end

-- Scene event functions

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Load the previous scores
    loadScores()

    -- Insert the saved score from the last game into the table, then reset it
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )

    -- Sort the table entries from highest to lowest
    local function compare ( a, b )
        return a > b
    end
    table.sort( scoresTable, compare )

    -- Save the scores
    saveScores()

    --Load background

    local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 130, "fonts/blackchancery", 70 )
    highScoresHeader:setFillColor( 0.9, 0.9, 0.3 )

    for i = 1, 5 do
        if ( scoresTable[i] ) then
            local yPos = 170 + ( i * 100 )

            local rankNum = display.newText( sceneGroup, i .. ".", display.contentCenterX -400, yPos, "fonts/blackchancery", 50 )
            rankNum:setFillColor( 0.8 )
            rankNum.anchorX = 1

            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX -350, yPos, "fonts/blackchancery", 50 )
            thisScore.anchorX = 0
        end
    end

    -- Back to Menu
    local menuButton = display.newImageRect( sceneGroup, "img/menu.png", 100, 100 )
    menuButton.x = display.contentCenterX + 170
    menuButton.y = display.contentCenterY + 160

    local menuText = display.newText( sceneGroup, "Menu", display.contentCenterX, 700, "fonts/blackchancery", 44 )
    menuText:setFillColor( 1, 1, 1 )
    menuText.x = menuButton.x + 135 
    menuText.y = menuButton.y

    -- Play again
    local playAgainButton = display.newImageRect( sceneGroup, "img/play.png", 100, 100 )
    playAgainButton.x = menuButton.x
    playAgainButton.y = menuButton.y - 200

    local playAgainText = display.newText( sceneGroup, "Play again", display.contentCenterX, 700, "fonts/blackchancery", 44 )
    playAgainText:setFillColor( 1, 1, 1 )
    playAgainText.x = playAgainButton.x + 180
    playAgainText.y = playAgainButton.y

    -- Go to
    menuButton:addEventListener( "tap", gotoMenu )
    menuText:addEventListener( "tap", gotoMenu )
    playAgainButton:addEventListener( "tap", gotoGame )
    playAgainText:addEventListener( "tap", gotoGame )

end

-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still of screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end

-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        composer.removeScene( "highscores" )
    end
end

-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
end

-- Scene event function listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene