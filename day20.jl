function readTiles()
    input = readlines("day20.txt")
    tid = 0
    tiles = Dict()
    for line in input
        if (line == "")
            continue
        end
        if (startswith(line, "Tile"))
            _, tid = split(line, [' ',':'])
            tid = parse(Int, tid)
        else
            if(tid in keys(tiles))
                tiles[tid] = cat(tiles[tid],collect(line),dims=2)
            else
                tiles[tid] = collect(line)
            end
        end
    end

    return tiles
end

function sides(tile)
    return [tile[1,:],tile[end,:],tile[:,1],tile[:,end]]
end

function rotations(tile)
    rotations = [[tile]; [rotr90(tile)]; [rot180(tile)]; [rotl90(tile)]]
    rtile = reverse(tile, dims=2)
    rotations = [rotations; [rtile]; [rotr90(rtile)]; [rot180(rtile)]; [rotl90(rtile)]]
    rttile = reverse(tile, dims=1)
    rotations = [rotations; [rttile]; [rotr90(rttile)]; [rot180(rttile)]; [rotl90(rttile)]]

    return unique(rotations)
end

function align(tile1, tile2)
    matches = [(1,3),(3,1),(2,4),(4,2)]
    s1s = sides(tile1)
    s2s = sides(tile2)

    for (i1,s1) in enumerate(s1s)
        for (i2,s2) in enumerate(s2s)
            if(s1 == s2)
                return (i1,i2)
            end

            if(s1 == reverse(s2))
                return (i1,-i2)
            end
        end
    end

    #for m in matches
     #   if(s1[m[1]] == s2[m[2]] || s1[m[1]] == reverse(s2[m[2]]))
     #       return m
     #   end
    #end

    return nothing
end

function firstNeighbour(idx, tilemap)
    offsets = [(1,0),(0,1),(-1,0),(0,-1)]

    neighbours = []
    for offset in offsets
        nidx = Tuple(idx) .+ offset
        if (checkbounds(Bool, tilemap, nidx...))
            return CartesianIndex(nidx...)
        end
    end

    return nothing
end

function permute(tiles, tilemap, friends)
    empty = []
    alreadyPlaced = []

    for idx in CartesianIndices(size(tilemap))
        if(tilemap[idx] == (0,0))
            empty = [empty; idx]
        else
            # Sort the positions by taking the ones with most neighbours first
            alreadyPlaced = [alreadyPlaced; tilemap[idx][1]]
        end
    end

    offsets = [(1,0),(0,1),(-1,0),(0,-1)]
        
    emptyTuples = map(e->Tuple(e), empty)
    emptyNeighbours = map(c->Dict("pos"=>c, "neighbours"=>map(offset->Tuple(c).+offset, offsets)), empty)
    #println("Empty: " , emptyTuples)
    #println("Neighbours", emptyNeighbours)

    free = map(p->(p["pos"],count(c->c in emptyTuples, p["neighbours"])), emptyNeighbours)
    #println("Free: " , free)


    if (length(empty) === 0)
        return tilemap
    end

    #println("Already placed: ", alreadyPlaced)
    #println("Remaining: ", remaining)
    remaining = filter(tid->!(tid in alreadyPlaced), collect(keys(tiles)))

    for (toplace, free) in sort(free, by=c->c[2])
        neighbours = []
        suitable = remaining

        # Check neighbours
        for offset in offsets
            nidx = Tuple(toplace) .+ offset
            if (checkbounds(Bool, tilemap, nidx...))
                neighbour = tilemap[nidx...]
                if (neighbour == (0,0))
                    continue
                end

                neighbours = [neighbours; neighbour[1]]
            end
        end

        # find the intersection of friends of neighbours
        for n in neighbours
            suitable = filter(s->s in friends[n],suitable)
        end

        #println("Suitable: ", suitable)
        # Take the tiles with least friends first
        suitableFriends = map(s->(s,length(friends[s])),suitable)

        for (tid,friendCount) in sort(suitableFriends, by=s->s[2])
            # Try placing rotation in map by checking consistency
            #println("Trying to place ", tid, " at ", toplace)
            tilemap[toplace] = (tid, 1)
            if (permute(tiles, tilemap, friends) !== false)
                return tilemap
            else
                println("Backtrack")
                tilemap[toplace] = (0,0)
            end
        end
    end

    return false
end

function part1()
    tiles = readTiles() 
    friends = Dict()
    for tid in keys(tiles)
        for otid in keys(tiles)
            if(tid !== otid)
                if align(tiles[tid], tiles[otid]) !== nothing
                    if(tid in keys(friends))
                        friends[tid] = [friends[tid]; otid]
                    else
                        friends[tid] = [otid]
                    end
                end
            end
        end
    end

    d = Int(sqrt(length(tiles)))
    tilemap = fill((0,0),(d,d))

    tilemap = permute(tiles, tilemap, friends)
    println(tilemap[1,1][1]*tilemap[1,end][1]*tilemap[end,1][1]*tilemap[end,end][1])
    return tilemap
end

function part2()
    tiles = readTiles() 
    tilemap = part1()
    offsets = [(1,0),(0,1),(-1,0),(0,-1)]

    ops = []
    for idx in CartesianIndices(tilemap)
        # Get orientation wrt next neighbour
        nidx = firstNeighbour(idx, tilemap)
        ops = [ops; align(tiles[tilemap[idx][1]], tiles[tilemap[nidx][1]])]
    end

    println(length(ops) - length(unique(ops)))
end

#part1()
print("\n")
part2()
