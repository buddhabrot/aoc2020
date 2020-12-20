function readTiles(file)
    input = readlines(file)
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
    return [tile[1,:],tile[:,1],tile[end,:],tile[:,end]]
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
    tiles = readTiles("day20.txt") 
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

function seamonsters(tilemap)
    sm = split("                  # ;#    ##    ##    ###; #  #  #  #  #  #   ",';')
    
    total = []
    for i=1:size(tilemap)[1]
        for j=1:size(tilemap)[2]
            found = true
            for p=0:19
                for k=0:2
                    if(!checkbounds(Bool, tilemap, j+k, i+p))
                        found = false
                        break
                    end
                    t = tilemap[j+k, i+p]
                    if(sm[k+1][p+1] == ' ' || t == '#')
                        found = found
                    else
                        found = false
                        break
                    end
                end
                if (!found)
                    break
                end
            end
            if (found)
                # seamonster found
                total = [total; (i,j)]
            end
        end
    end

    return total
end

function part2()
    tiles = readTiles("day20.txt") 
    d = Int(floor(sqrt(length(collect(values(tiles))))))
    tilemap = part1()

    aligned = fill(fill('.',size(collect(values(tiles))[1])), (d,d))

    for row in 1:d
        prevtile = tiles[tilemap[row,1][1]]
        tile = tiles[tilemap[row,2][1]]

        found = false

        for rot1 in rotations(prevtile)
            for rot2 in rotations(tile)
                if row > 1
                    condition = align(aligned[row-1,1],rot1) == (3,1)
                else
                    condition = true
                end

                if(align(rot1,rot2) == (4,2) && condition)
                    aligned[row,1] = rot1
                    aligned[row,2] = rot2
                    prevtile = rot2
                    found = true
                    break
                end
            end

            if (found)
                break
            end
        end

        if (!found)
            println("Cannot stitch...", row)
            return
        end


        for (idx,tile) in enumerate(tilemap[row,3:end])
            found = false

            for rot in rotations(tiles[tile[1]])
                if(align(aligned[row,idx+1],rot) == (4,2))
                    aligned[row,idx+2] = rot
                    found = true
                    break
                end
            end

            if (!found)
                println("Cannot stitch...", row, ",", idx+2)
                return
            end
        end
    end

    rows = []
    for row = 1:d
        trimmed = cat(map(a->a[2:end-1,2:end-1],aligned[row,:])...,dims=2)
        rows = [rows; [trimmed]]
    end

    trimmed = cat(rows..., dims=1)
    
    for rot in rotations(trimmed)
        sms = seamonsters(rot)
        total = count(c->c=='#', rot)

        if(length(sms) > 0)
            println(total-length(sms)*15) # 15 #'s in seamonster pattern
            return
        end
    end
end

part1()
print("\n")
part2()
