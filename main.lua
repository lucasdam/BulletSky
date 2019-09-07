local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Seed the random number generator
math.randomseed( os.time() )

-- Set up display groups
local backGroup = display.newGroup()
local mainGroup = display.newGroup()

-- Background
local background = display.newImageRect( backGroup, "img/background.png", 580, 320 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- Girl
local girl = display.newImageRect( mainGroup, "img/girl.png", 50, 50 )
girl.x = display.contentWidth -450
girl.y = display.contentCenterY 
physics.addBody( girl, {radius=30, isSensor=true} )
girl.myName = "girl"

-- Orbs
local function createOrb()
    local newOrb = display.newImageRect( mainGroup, "img/purpleBall", 50, 50 )
    table.insert( orbsTable, newOrb )
    physics.addBody( newOrb, "dynamic", {radius=40, bounce=0.8} )
    newOrb.myName = "orb"

    local whereFrom = math.random( 3 )

    if (whereFrom == 1) then
        -- From the left
        newOrb.x = -60
        newOrb.y = math.random( 500 )
        newOrb:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
    elseif ( whereFrom == 2 ) then
        -- From the top
        newOrb.x = math.random( display.contentWidth )
        newOrb.y = -60
        newOrb:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newOrb.x = display.contentWidth + 60
        newOrb.y = math.random( 500 )
        newOrb:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) ) 
    end

    newOrb:applyTorque( math.random( -6,6 ) )
end
