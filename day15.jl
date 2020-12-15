numbers = map(s->parse(Int,s),readlines("day15.txt"))

function part1()
    part2(2020)
end

function part2(turns)
    positions = Dict{Int,Array}()
    for (idx,n) in enumerate(numbers) 
        positions[n] = [idx,idx]
    end
    
    seen = numbers[end]

    i = length(numbers)+1
    while i<=turns
        if (seen in keys(positions))
            n = positions[seen][1] - positions[seen][2]
        else
            n = 0
        end

        if (n in keys(positions))
            positions[n] = [i, positions[n][1]]
        else
            positions[n] = [i,i]
        end 

        seen = n    

        i += 1
    end

    print(seen, "\n")
end

part1()
part2(30000000)