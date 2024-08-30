    player0x = 12 : player0y = 50
    player1x = 137 : player1y = 50
    missile0x = 75 : missile0y = 50
    dim direction = a
    dim gameMode = b
    dim counter = c
    gameMode{0} = 0

    playfield:
    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    .................................
    .................................
    .................................
    .................................
    .................................
    .................................
    .................................
    .................................
    .................................
    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end

resetGame
    a=0 : c=0
    player0x = 12 : player0y = 50
    player1x = 137 : player1y = 50
    missile0x = 75 : missile0y = 50
    score = 0
    
top
    player0:
    %111
    %111
    %111
    %111
    %111
    %111
    %111
    %111
    %111
end

    player1:
    %111
    %111
    %111
    %111
    %111
    %111
    %111
    %111
    %111
end

    if switchselect then counter = counter + 1
    if switchselect && gameMode{0} && counter = 30 then gameMode{0} = 0 : goto resetGame
    if switchselect && !gameMode{0} && counter = 30 then gameMode{0} = 1 : goto resetGame
    if counter = 30 then counter = 0 

    COLUBK = $9E
    COLUPF = $C4
    COLUP0 = $30
    COLUP1 = $30
    drawscreen

    if joy0down && player0y < 80 then player0y = player0y + 1
    if joy0up && player0y > 16 then player0y = player0y - 1

    if gameMode{0} then goto skip_computer
    if player1y < missile0y + 4 && player1y < 90 && (rand&13) <> 0 then player1y = player1y + 1
    if player1y > missile0y + 4 && player1y > 10 && (rand&13) <> 0 then player1y = player1y - 1

skip_computer
    if !gameMode{0} then goto skip_player_2
    if joy1down && player1y < 80 then player1y = player1y + 1
    if joy1up && player1y > 16 then player1y = player1y - 1

skip_player_2

    if direction{0} then missile0x = missile0x - 1
    if !direction{0} then missile0x = missile0x + 1
    if direction{1} then missile0y = missile0y - 1
    if !direction{1} then missile0y = missile0y + 1

    if collision(missile0, playfield) && missile0y > 50 then direction{1} = 1
    if collision(missile0, playfield) && missile0y < 50 then direction{1} = 0


    if collision(player0, missile0) then direction{0} = 0
    if collision(player0, missile0) && joy0down then direction{1} = 1
    if collision(player0, missile0) && joy0up then direction{1} = 0

    if collision(player1, missile0) then direction{0} = 1
    if collision(player1, missile0) && missile0y < player1y - 4 then direction{1} = 1
    if collision(player1, missile0) && missile0y > player1y - 4 then direction{1} = 0


    if missile0x = 2 then score = score - 1 : goto scorepoint
    if missile0x = 158 then score = score + 1 : goto scorepoint

    goto finishloop

scorepoint
    missile0x = 75 : missile0y = 50


finishloop
    goto top
