function input(fn)
    lines = readlines(fn)

    player1 = []
    player2 = []

    player = 1
    for line in lines
        if (line == "")
            continue
        end

        if (line == "Player 1:")
            continue
        end

        if (line == "Player 2:")
            player = 2
            continue
        end

        if (player == 1)
            pushfirst!(player1, parse(Int, line))
        else
            pushfirst!(player2, parse(Int, line))
        end
    end

    return (player1,player2)
end

function play(deck1, deck2)
    if (length(deck1) * length(deck2) == 0)
        score = 0
        for (idx,card) in enumerate([deck1;deck2])
            score += idx * card
        end
        if (length(deck1) > length(deck2))
            return score
        else
            return score
        end
    end
        
    p1 = pop!(deck1)
    p2 = pop!(deck2)

    if (p1 > p2)
        pushfirst!(deck1,p2,p1)
    else
        pushfirst!(deck2,p1,p2)
    end

    return nothing
end

function rplay(deck1, deck2, seen, memo, depth)
    cache = string(join(deck1,","),":",join(deck2,",")) 

    # Memoization
    if (cache in keys(memo))
        return memo[cache]
    end

    if (cache in keys(seen))
        memo[cache] = (1, 0)
        return memo[cache]
    else
        seen[cache] = 1
    end

    if (length(deck1) * length(deck2) == 0)
        score = 0
        for (idx,card) in enumerate([deck1;deck2])
            score += idx * card
        end
        #println("part2: ", score)
        if (length(deck1) > length(deck2))
            memo[cache] = (1, score)
            return memo[cache]
        else
            memo[cache] = (2, score)
            return memo[cache]
        end
    end
        
    p1 = pop!(deck1)
    p2 = pop!(deck2)

    if (p1 <= length(deck1) && p2 <= length(deck2))
        # Play recursive game
        copy1 = copy(deck1[end-p1+1:end])
        copy2 = copy(deck2[end-p2+1:end])

        nseen = Dict()
        cache = string(join(copy1,","),":",join(copy2,",")) 
        while (winner = rplay(copy1, copy2, nseen, memo, depth+1)) === nothing
        end
        memo[cache] = winner # memoize to skip recursion
    else
        if (p1 > p2)
            winner = (1,0)
        else
            winner = (2,0)
        end
    end
    
    if winner[1] == 1
        pushfirst!(deck1,p2,p1)
    else
        pushfirst!(deck2,p1,p2)
    end

    return nothing
end

function part1() 
    (player1,player2) = input("day22.txt")

    while (winner = play(player1, player2)) === nothing
    end

    print(winner)
end

function part2() 
    (player1,player2) = input("day22.txt")
    seen = Dict()
    memo = Dict()
    while (winner = rplay(player1, player2, seen, memo, 1)) === nothing
    end

    print(winner)
end

part1()
println()
part2()