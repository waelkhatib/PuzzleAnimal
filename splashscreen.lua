local composer = require( "composer" )
local scene = composer.newScene()

-- set default screen background color to blue
-- display.setDefault( "background", 255, 255, 255 )

-- "scene:create()"
function scene:create( event )
	local sceneGroup = self.view

	local title = display.newImage("resource/IMG/".._G.logoScreenSplash)
	local loadMenu = function()
		title = nil	
		composer.gotoScene( "menu" , "fade")
	end

	local initVars = function ()
		sceneGroup:insert(title)

		title.x = display.contentCenterX
		title.y = display.contentCenterY

		timer.performWithDelay(2000, loadMenu) 
	end

	initVars()
end

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
end

-- "scene:destroy()"
function scene:destroy( event )
    local sceneGroup = self.view
end


function scene:hide( event )
    local sceneGroup = self.view

    local phase = event.phase

    if ( phase == "will" ) then
      local removeAll;
    
      removeAll = function(group)
        if group.enterFrame then
          Runtime:removeEventListener("enterFrame", group);
        end
        if group.touch then
          group:removeEventListener("touch", group);
          Runtime:removeEventListener("touch", group);
        end     
        for i = group.numChildren, 1, -1 do
          if group[i].numChildren then
            removeAll(group[i]);
          else
            if group[i].enterFrame then
              Runtime:removeEventListener("enterFrame", group[i]);
            end
            if group[i].touch then
              group[i]:removeEventListener("touch", group[i]);
              Runtime:removeEventListener("touch", group[i]);
            end
          end
        end
      end

      removeAll(self.view);
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )


-- -------------------------------------------------------------------------------

return scene

