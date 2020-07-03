screen_width = 590
screen_height = 636
max_jim = 10
time = 10
jim_removed = 0

player = {
    src = "playerPic.png",
    width = 64,
    height = 64,
    x = screen_width/2 - 64/2,
    y = screen_height - 64
}

jims = {}
kisses = {}

--PLAYER
--==========================================================================================
function movePlayer()
    if love.keyboard.isDown('w') then
        player.y = player.y - 8
    end
    if love.keyboard.isDown('a') then
        player.x = player.x - 8
    end
    if love.keyboard.isDown('s') then
        player.y = player.y + 8
    end
    if love.keyboard.isDown('d') then
        player.x = player.x + 8
    end
end 
--==========================================================================================

--GUI 
--==========================================================================================
function createJim()
    each_jim = {
        x = math.random(1, screen_width),
        y = -64,
        width = 64,
        height = 64,
        weight = math.random(4),
        movement_hor = math.random(-1, 1)
    }
    table.insert(jims, each_jim)
end

function moveJim()
    for k, each_jim in pairs(jims) do
        each_jim.x = each_jim.x + each_jim.movement_hor
        each_jim.y = each_jim.y + each_jim.weight
    end
end

function removeJim()
    for i = #jims, 1, -1 do
        if jims[i].y > screen_width then
            table.remove(jims, i)
        end
    end
end
--==========================================================================================

--KISS
--==========================================================================================
function giveKiss(kx, ky, dx, dy)
    kiss = {
        x = kx,
        y = ky + 5,
        weight = dx,
        movement_hor = dy
    }
    table.insert(kisses, kiss)
end

function moveKiss()
    for k, kiss in pairs(kisses) do
        kiss.x = kiss.x + kiss.movement_hor
        kiss.y = kiss.y + kiss.weight
    end
end

function removeKiss()
    for i = #kisses, 1, -1 do
        if kisses[i].y > screen_width then
            table.remove(kisses, i)
        end
    end
end
--==========================================================================================

--COLISAO
--==========================================================================================
function checkColision()
    checkColisionPeople()
end

function isColided(x1, y1, a1, l1, x2, y2, a2, l2)
    return  x2 < x1 + l1 and
            x1 < x2 + l2 and
            y1 < y2 + a2 and
            y2 < y1 + a1  
end

function checkColisionPeople()
    for k, each_jim in pairs(jims) do --k = #jims, 1, -1 do
        if isColided(each_jim.x, each_jim.y, each_jim.height, each_jim.width, player.x, player.y, player.height, player.width)
        then
            table.remove(jims, k) 
            jim_removed = jim_removed + 1
            giveKiss(each_jim.x, each_jim.y, each_jim.weight, each_jim.movement_hor)
        end
    end
end
--==========================================================================================

--AFTER
--==========================================================================================
function afterTime()
    removeKiss()
    removeJim()
    moveKiss()
    moveJim()
    checkColision()
end
--==========================================================================================

-- Load some default values for our rectangle.
function love.load()
    love.window.setMode(screen_width, screen_height, {resizable = false})
    love.window.setTitle("Kiss Game")

    math.randomseed(os.time())
    
    player.imagem = love.graphics.newImage(player.src)

    background = love.graphics.newImage("backgroundHeartHor2.jpg")
    startHeart = love.graphics.newImage("heartMenu.png")

    jimHalpert = love.graphics.newImage("jimHalpert.png")
    kiss_img= love.graphics.newImage("overKiss.png")

    startGame = false
    startMenu = true
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
    if time > 0 and startGame == true then
        if love.keyboard.isDown('w', 'a', 's', 'd') then
            movePlayer()
        end
        if #jims < jim
    hen
            createJim()
        end
        
        removeKiss()
        removeJim()
        moveKiss()
        moveJim()
        checkColision()
        time = time - dt
    end
    afterTime()
    if (time <= 0) then
        finalMenu = true
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" then
        startGame = true
        startMenu = false
        finalMenu = false
        time = 10
        jim_removed = 0
        player.x = screen_width/2 - 64/2
        player.y = screen_height - 64        
    end
end
 
-- Draw a coloured rectangle.
function love.draw()
    --love.graphics.setColor(0.5, 0.4, 0.5)

    love.graphics.draw(background, 0, 0)
    font = love.graphics.newFont(12)
    love.graphics.setFont(font)
    love.graphics.print(string.format("Remaining Time: %.1f", time), 0)
    love.graphics.print(string.format("Kisses Given: " .. (jim_removed)), 0, 15)

    for k, each_jim in pairs(jims) do
        love.graphics.draw(jimHalpert, each_jim.x, each_jim.y)
    end
    for k, kiss in pairs(kisses) do
        love.graphics.draw(kiss_img, kiss.x, kiss.y)
    end

    if finalMenu == true then
        love.graphics.setFont(font1)
        love.graphics.draw(startHeart, screen_width/2 - 450/2, screen_height/2 - 428/2 - 80)
        love.graphics.printf(string.format("PAM HAS KISSED JIM:\n%d TIMES!!", jim_removed), screen_width/3, screen_height/2 - 90, 200, "center")   
        love.graphics.printf("Press 'ENTER' to kiss some more!", screen_width/3, screen_height/2 + 30, 200, "center")
    elseif (startMenu == true) and time == 10 then
        love.graphics.draw(startHeart, screen_width/2 - 450/2, screen_height/2 - 428/2 - 80)
        font1 = love.graphics.newFont(25)
        font2 = love.graphics.newFont(16)

        love.graphics.setFont(font1)
        love.graphics.print("KISS AS MUCH AS YOU CAN!", screen_width/3 - 75, screen_height/3 + 10)

        love.graphics.setFont(font2)
        love.graphics.printf("CONTROLS:\n\nenter - start\nesc - exit\nw - move up\na - move left\ns - move down\nd - move right\n", screen_width/3, screen_height/2 - 50, 200, "center")
    else
        love.graphics.draw(player.imagem, player.x, player.y)
    end

end