function getZeroMask(mask)
    return parse(Int,join(map(c->if c == '0' return '1' else return '0' end, collect(mask))), base=2)
end

function getOneMask(mask)
    return parse(Int, join(map(c->if c == '1' return '1' else return '0' end, collect(mask))), base=2)
end

function part1()
    lines = readlines("day14.txt")
    groups = []
    zmask = nothing
    omask = nothing
    mem = Dict{Int,Int}()

    for line in lines
        stmt = split(line, " = ")
        if (stmt[1] == "mask")
            zmask = getZeroMask(stmt[2])
            omask = getOneMask(stmt[2])
        else
            re = match(r"mem\[(\d*)\] = (\d*)", line)
            index = parse(Int, re.captures[1])
            value = parse(Int, re.captures[2])

            value = (value | omask) & ~zmask

            mem[index] = value
        end
    end

    return sum(values(mem))
end

function permutations(xmask)
    # x mask is encoded as 1's for xx's
    if(length(xmask) == 1)
        if(xmask[1] == 'X')
            return ['0','1']
        else
            return [xmask[1]]
        end
    end

    perms = permutations(xmask[2:end])

    if(xmask[1] == 'X')
        return [[string('0', permutation) for permutation in perms]; [string('1', permutation) for permutation in perms]] 
    else
        return [string(xmask[1], permutation) for permutation in perms]
    end
end

function part2()
    lines = readlines("day14.txt")
    groups = []
    zmask = nothing
    omask = nothing
    xmask = nothing

    mem = Dict{Int,Int}()
    perms = [] 

    for line in lines
        stmt = split(line, " = ")
        if (stmt[1] == "mask")
            xmask = collect(stmt[2])
        else
            re = match(r"mem\[(\d*)\] = (\d*)", line)

            xindex = copy(xmask)
            value = parse(Int, re.captures[2])

            # collects input as bit string
            bits = collect(bitstring(parse(Int,re.captures[1])))[end-35:end]
            
            bits[xmask.=='X'] .= 'X'
            bits[xmask.=='1'] .= '1'

            perms = permutations(bits)

            for perm in perms
                idx = parse(Int, perm, base=2)
                mem[idx] = value
            end
        end
    end

    return sum(values(mem))
end



print(part1())
print("\n")
print(part2())
