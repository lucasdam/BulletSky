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

    if ( scoresTable == nil or #scoresTable == 0 ) then
        scoresTable = {0, 0, 0, 0}
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


local function gotoMenu()
    composer.gotoScene( "menu", {time=800, effect="crossFade"} )
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

    local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 170, native.system, 60 )

    for i = 1, 3 do
        if ( scoresTable[i] ) then
            local yPos = 170 + ( i * 100 )

            local rankNum = display.newText( sceneGroup, i .. ".", display.contentCenterX -100, yPos, native.systemFont, 50 )
            rankNum:setFillColor( 0.8 )
            rankNum.anchorX = 1

            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX -50, yPos, native.systemFont, 50 )
            thisScore.anchorX = 0
        end
    end

    local menuButton = display.newText( sceneGroup, "Menu", display.contentWidth - 50, display.contentCenterY + 200, native.systemFont, 40 )
    menuButton:setFillColor( 1, 1, 1 )
    menuButton:addEventListener( "tap", gotoMenu )
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