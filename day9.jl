PREAMBLE_LENGTH = 25

sequence = map(s->parse(Int,s),readlines("day9.txt"))

function isSumOfTwo(numbers, sum)
    for n in numbers
        if (sum-n) in numbers && (sum-n != n)
            return true
        end
    end

    return false
end

function part1()
    for i in 1:length(sequence)-PREAMBLE_LENGTH-1
        candidate = sequence[i+PREAMBLE_LENGTH+1]
        if !isSumOfTwo(sequence, candidate)
            return candidate
        end
    end
end

function part2()
    s = part1()
    # O(n2) 
    for start in 1:length(sequence)
        for len in 1:length(sequence)-start
            seq = sequence[start:start+len]
            if (sum(seq) == s)
                return minimum(seq) + maximum(seq)
            end
        end
    end
end

part2()