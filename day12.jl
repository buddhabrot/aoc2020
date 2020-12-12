function doMove(pos, dir, instruction, amount)
    if(instruction == "N")
        return pos .+ (0,-1) .* amount,dir
    end

    if(instruction == "S")
        return pos .+ (0,1) .* amount,dir
    end

    if (instruction == "W")
        return pos .+ (-1, 0) .* amount,dir
    end

    if (instruction == "E")
        return pos .+ (1, 0) .* amount,dir
    end

    if (instruction == "F")
        return pos .+ (dir .* amount),dir
    end

    dirs = [(1,0),(0,-1),(-1,0),(0,1),(1,0),(0,-1),(-1,0),(0,1)]
    mod = Int(amount/90)

    current = findfirst(c->c==dir, dirs)

    if (instruction == "L")
        return pos,dirs[current+mod]
    end

    if (instruction == "R")
        return pos,dirs[current+4-mod]
    end
end

function rot(v, instruction, angle)
    amount = Int(angle/90)
    
    nx = v[1]
    ny = v[2]

    if(amount==0  || amount==4)
        return nx,ny
    end

    if (instruction == "L")
        for turn in 1:amount
            kx = nx
            nx = ny 
            ny = -kx
        end
    end 

    if (instruction == "R")
        for turn in 1:amount
            kx = nx
            nx = -ny  
            ny = kx
        end
    end 

    return nx,ny
end

function parseMove(move)
    re = match(r"([NSEWLRF])(\d*)", move)
    return re.captures[1],parse(Int,re.captures[2])
end

function part1()
    moves = readlines("day12.txt")
    dir = (1,0)
    pos = (0,0)
    for move in moves
        instruction,amount = parseMove(move)
        #print(instruction, ",", amount, "\n")
        pos,dir = doMove(pos,dir,instruction,amount)
    end

    print(abs(pos[1]) + abs(pos[2]))
end

function part2()
    moves = readlines("day12.txt")
    pos = (0,0)
    wpos = (10,-1)
    for move in moves
        instruction,amount = parseMove(move)
        #print(instruction, ",", amount, "\n")
        
        if (instruction in ["N","S","W","E"]) # move waypoint
            wpos, _ = doMove(wpos, (0,0), instruction, amount)
        end

        if (instruction == "F") # get dir between wp and ship and move ship
            pos, dir = doMove(pos, wpos, instruction, amount)
        end

        if (instruction in ["L", "R"])
            wpos = rot(wpos,instruction,amount)
        end
    end

    print(abs(pos[1]) + abs(pos[2]))
end

part1()

print("\n")
part2()