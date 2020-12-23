function printSeq(next)
    s = ""
    a = 1
    for i=1:length(keys(next))
        s = string(s,a)
        a = next[a]
    end
    return s
end

function solve(moves, input,pad)
    next = Dict()
    input = map(c->parse(Int,c),collect(input))
    input = [input;pad]
    for (idx,i) in enumerate(input[1:end-1])
        next[i] = input[idx+1]
    end
    next[input[end]] = input[1]
    
    current = input[1]
    max = maximum(keys(next))

    for move = 1:moves
        firstTake = next[current]
        secondTake = next[firstTake]
        thirdTake = next[secondTake]
        afterTake = next[thirdTake]

        destination = current - 1
        if (destination < 1) 
            destination = max
        end

        while destination in [firstTake,secondTake,thirdTake]
            destination -= 1
            if (destination < 1) 
                destination = max
            end
        end

        next[current] = afterTake
        keep = next[destination]
        next[destination] = firstTake
        next[thirdTake] = keep

        current = afterTake
    end
    
    return next
end

function part1()
    n = solve(100, "974618352",[])
    println(printSeq(n))
end

function part2()
    n = solve(10000000, "974618352",10:1000000)
    l = n[1]
    r = n[l]

    println(l,",",r,",", l * r)
end

part1()
println()
part2()