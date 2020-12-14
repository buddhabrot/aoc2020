function part1()
    lines = readlines("day13.txt")
    ts = parse(Int, lines[1])
    buses = split(lines[2],",")

    minimum = 0
    minimumBus = 0

    for b in buses
        if b == "x"
            continue
        end

        b = parse(Int,b)

        dt = Int(b*(floor(ts/b)+1) - ts)

        if (minimum == 0 || dt < minimum)
            minimum = dt
            minimumBus = b
        end
    end

    return minimumBus * minimum
end

function part2()
    lines = readlines("day13.txt")
    _ = parse(Int, lines[1])
    buses = [x for x in enumerate(split(lines[2],","))]

    t = 0
    multiplier = 1

    while true
        found = true
        for bus in buses
            if (bus[2] == "x")
                continue
            end

            bt = Int128(t + bus[1] - 1)
            b = parse(Int, bus[2])

            #print("Checking if ", b, " divides ", bt, ": ", mod(bt, b) ,"\n")

            if (mod(bt, b) != 0)
                found = false
                break
            else
                if (mod(multiplier, b) != 0)
                    multiplier *= b # jump to the next point where these align
                end
            end
        end

        if found
            return t
        end

        t += multiplier

        if (t > 10000000000000000000)
            print("Early exit to prevent inf loop: ")
            return t
        end
    end
end


print(part1())
print("\n")
print(part2())