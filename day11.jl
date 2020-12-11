@enum Seat occupied empty floor unset

function toType(c)
    if (c=='L')
        return empty
    end

    if (c=='#')
        return occupied
    end

    if (c=='.')
        return floor
    end
end

# Surround with floors for easy iteration
seats = hcat(map(s->map(toType,collect((s))),readlines("day11.txt"))...)

hFloor = fill(floor,(length(seats[:,1]),1))
vFloor = fill(floor,(1,length(seats[1,:])+2))
seats = hcat(hFloor,seats,hFloor)
seats = vcat(vFloor,seats,vFloor)

function part1(seats)
    offsets = filter(n->n!=(0,0),vcat(collect(Iterators.product(-1:1, -1:1))...))

    changed = true
    while(changed)
        next = fill(floor, size(seats))
        changed = false
        for i in CartesianIndices(seats[2:end,2:end])
            next[i] = seats[i]

            if (seats[i] == floor)
                continue
            end

            occ = 0
            for offset in offsets
                neighbour = Tuple(i).+offset
                if(seats[neighbour...] == occupied)
                    occ += 1
                end
            end

            if (occ == 0 && seats[i] == empty)
                next[i] = occupied
            end

            if (occ >= 4 && seats[i] == occupied)
                next[i] = empty
            end

            changed |= next[i] != seats[i]
        end

        seats = next
    end

    return count(s->s==occupied,seats)
end

function part2(seats)
    changed = true
    while(changed)
        next = fill(floor, size(seats))
        changed = false
        for i in CartesianIndices(seats[2:end,2:end])
            next[i] = seats[i]

            if (seats[i] == floor)
                continue
            end

            occ = 0
            offsets = filter(n->n!=(0,0),vcat(collect(Iterators.product(-1:1, -1:1))...))

            # Scan rays, starting small and growing outwards
            for dist in 1:length(seats[:,1])
                for offset in offsets
                    neighbour = Tuple(i).+offset.*dist
                    if(!checkbounds(Bool, seats, neighbour...))
                        continue
                    end

                    if(seats[neighbour...] == empty || seats[neighbour...] == occupied)
                        # remove offset from candidates
                        offsets = filter(n->n!=offset,offsets)
                    end

                    if(seats[neighbour...] == occupied)
                        occ += 1
                    end
                end
            end

            if (occ == 0 && seats[i] == empty)
                next[i] = occupied
            end

            if (occ >= 5 && seats[i] == occupied)
                next[i] = empty
            end

            changed |= next[i] != seats[i]
        end

        seats = next
    end

    return count(s->s==occupied,seats)
end

print("Part 1\n",part1(seats),"\n")
print("Part 2\n",part2(seats),"\n")

