adapters = sort(map(s->parse(Int,s),readlines("day10.txt")))
adapters = [0;adapters;maximum(adapters)+3]

function part1()
    last = 0
    ones = 0
    threes = 0
    for adapter in adapters
        if (adapter-last == 1)
            ones += 1
        end

        if (adapter-last == 3)
            threes += 1
        end
        last = adapter
    end

    return ones * threes
end

function part2()
    last = 0
    ones = 0
    subTotals = 0
    totals = 1

    # In O(n) make map with freedom of going elsewhere per adapter
    freeOut = map(((idx,a), ) -> length(filter(na -> na-a<=3, adapters[min(idx+1,length(adapters)): min(idx+3,length(adapters))])), enumerate(adapters))
    
    # In O(n) make map with freedom of ending up here per adapter
    # Note: ended up not using this but leaving it in
    freeIn = map(((idx,a), ) -> length(filter(na -> a-na<=3, adapters[max(idx-3,1): max(idx-1,1)])), enumerate(adapters))   

    getTotalFreedom(1, freeOut)
end

# Use memoization
memo = Dict()

function getTotalFreedom(idx, freedoms)
    if(idx in keys(memo))
        return memo[idx]
    end

    if (idx>length(freedoms))
        return 1
    end

    totals = 0
    freedom = freedoms[min(idx,length(freedoms))]
    for i in 1:freedom
        totals += getTotalFreedom(idx+i, freedoms)
    end

    memo[idx] = totals
    return totals
end

print(part1(),"\n")
print(part2(),"\n")
