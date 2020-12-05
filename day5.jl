lines = readlines("day5.txt")

function to_binary(char)
    if(char == 'B' || char == 'R')
        return '1'
    end

    if(char == 'F' || char == 'L')
        return '0'
    end
end

function getSeat(line)
    # Note: Split in row/col is not required but Part 2 of this Day might need it
    rowCode = map(to_binary,line[1:7])
    colCode = map(to_binary,line[8:10])

    row = parse(Int, rowCode, base=2)
    col = parse(Int, colCode, base=2)

    seat = row * 8 + col

    return seat
end

function getMissingSeats(seats)
    maxSeat = maximum(seats)
    minSeat = 0
    hasSeat = Dict()

    for seat in seats
        hasSeat[seat] = true
    end

    missing = []

    for i in minSeat:maxSeat
        if(!haskey(hasSeat,i))
            missing = [missing;i]
        end
    end

    return missing
end

seats = map(getSeat, lines)
maxSeat = maximum(seats)
print("max: ", maxSeat, "\n")
missingSeats = getMissingSeats(seats)
print("missing: ", maximum(missingSeats), "\n")