M = Dict("e"=>(2,0), "se"=>(1,-1), "sw"=>(-1,-1), 
         "w"=>(-2,0), "nw"=>(-1,1), "ne"=>(1,1))

function get(line)
    a = collect(line)
    
    r = []
    while(length(a) > 0)
        s = string(popfirst!(a))
        if (!haskey(M, s))
            s = string(s, popfirst!(a))
            m = M[s]
        else
            m = M[s]
        end
        r = [r;m]
    end

    return r
end

function getTiles(lines)
    blacks = Dict()

    for line in lines
        if (line == "")
            continue
        end

        moves = get(line)
        dst = reduce((x, y) -> x .+ y, moves)

        if (haskey(blacks, dst))
            blacks[dst] = ~blacks[dst]
        else
            blacks[dst] = true
        end
    end

    return blacks
end

function part1()
    blacks = getTiles(readlines("day24.txt"))
    return count(k->blacks[k], keys(blacks))
end

function part2()
    all = getTiles(readlines("day24.txt"))
    blacks = Dict()

    for a in keys(all)
        if (all[a]) 
            blacks[a] = true
        end
    end

    for i = 1:100
        nblacks = copy(blacks)
        all = collect(Iterators.flatten(map(c->[c;getAdjacent(c)], collect(keys(blacks)))))

        for t in all
            adjs = count(c->haskey(blacks,c), getAdjacent(t))
            if((adjs == 0 || adjs > 2) && haskey(blacks, t)) 
                nblacks[t] = false
            elseif(adjs == 2 && !haskey(blacks, t)) 
                nblacks[t] = true
            end
        end

        blacks = Dict()
        for a in keys(nblacks)
            if (nblacks[a]) 
                blacks[a] = true
            end
        end
    end

    return count(k->blacks[k], keys(blacks))
end

function getAdjacent(tile)
    return map(m->tile.+m, values(M))
end

println(part1())
println()
println(part2())
