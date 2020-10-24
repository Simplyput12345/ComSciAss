require 'srs/Dependencies'

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Chess')

    gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8)
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16)
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}
	
    love.graphics.setFont(gFonts['small'])

    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/piecechart.png'),
    }

    gFrames = {
        ['pawns'] = GenerateQuadsPaddles(gTextures['main']),
        ['knights'] = GenerateQuadsBalls(gTextures['main']),
        ['queens'] = GenerateQuadsPaddles(gTextures['main']),
        ['kings'] = GenerateQuadsBalls(gTextures['main']),
        ['bishops'] = GenerateQuadsBricks(gTextures['main']),
        ['rooks'] = GenerateQuadsBricks(gTextures['main']),
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    }

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('start')

    love.keyboard.keyspressed = {}
    function love.resize(w,h)
        push:resize(w,h)
    end
    function love.update(dt)
        gStateMachine:update(dt)
        love.keyboard.keyspressed = {}
    end
    function love.keyspressed(key)
        love.keyboard.keyspressed[key] = true
    end
    function love.keyboard.wasPressed(key)
        if love.keyboard.keyspressed[key] then
            return true
        else
            return false
        end
    end

function love.draw()
    push:apply('start')
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHight = gTextures['background'];getHeight()

    love.graphics.draw(gTextures['background'],
        0, 0, 0, VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHight - 1))
    gStateMachine:render()
    displayFPS()
    push:apply('end')
end
function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end