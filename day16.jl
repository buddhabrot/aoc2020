lines = readlines("day16.txt")

part = 0
rules = Dict()
myTicket = nothing
nearby = []

for line in lines
    global part
    global nearby
    global rules
    global myTicket

    if (line == "")
        part += 1
        continue
    end

    if part == 0
        f = split(line, ": ")
        z = split(f[2], " or ")
        title = f[1]
        predicates = []
        for i in z
            j = split(i, "-")
            from = parse(Int,j[1])
            to = parse(Int,j[2])
            predicates = [predicates; a -> from <= a && a <= to]
        end

        rules[title] = predicates
    end

    if part == 1
        myTicket = map(s->parse(Int,s),split(line, ","))
    end

    if part == 2
        nearby = [nearby; [map(s->parse(Int,s),split(line, ","))]]
    end
 
end


function part1()
    invalids = []
    for ticket in nearby
        for fld in ticket
            valid = false
            for pred in values(rules)
                if (pred[1](fld) || pred[2](fld))
                    valid = true
                    continue
                end
            end
            if (!valid)
                invalids = [invalids; fld]
            end
        end
    end
    #print(invalids, "\n")

    print(sum(invalids))
    #print(rules, "\n")
end


function part2()
    invalids = []
    validTickets = []

    for ticket in nearby
        isValidTicket = true
        for fld in ticket
            valid = false
            for pred in values(rules)
                if (pred[1](fld) || pred[2](fld))
                    valid = true
                    continue
                end
            end
            if (!valid)
                invalids = [invalids; fld]
                isValidTicket = false
            end
        end
        if (isValidTicket)
            validTickets = [validTickets; [ticket]]
        end
    end

    candidates = Dict()
    for ticket in validTickets
        for (idx,fld) in enumerate(ticket)
            fldCandidates = []
            for k in keys(rules)
                pred = rules[k]
                if (pred[1](fld) || pred[2](fld))
                    fldCandidates = [fldCandidates; k]
                end
            end
            if idx in keys(candidates)
                candidates[idx] = intersect(fldCandidates, candidates[idx] )
            else
                candidates[idx] = fldCandidates
            end
        end
    end

    all = zeros(Int, length(keys(candidates)))
    for k in keys(candidates)
        v = candidates[k]
        idx = length(v)
        all[idx] = k
    end

    taken = []
    for a in all
        candidates[a] = filter(c->!(c in taken),candidates[a])
        fields = candidates[a]
        taken = [taken; fields]
    end


    result = 1
    for k in keys(candidates)
        name = candidates[k][1]
        re = match(r"^departure", name)
        if (re != nothing)
            result *= myTicket[k]
        end
    end
    print(result)
end

part1()
print("\n")
part2()

