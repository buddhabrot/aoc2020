# Reduce regexp

function red(ids, graph, rules)
    repl = Dict()
    nids = []

    for id in unique(ids)
        r = rules[id]

        if (id in keys(graph))
            for usedin in unique(graph[id])
                rules[usedin] = replace(rules[usedin], string("(",id,")") => r)
                nids = [nids; usedin]
            end
        end
    end    

    # replace only towards rules that are fully resolved
    nids = filter(nid->!occursin(r"\d",rules[nid]), nids)

    if(length(nids) > 1)
        red(nids, graph, rules)
    end
end

function input(f, part2)
    lines = readlines(f)

    phrases = []
    rules = Dict()
    graph = Dict()
    terminals = []
    part = 0

    for line in lines
        if line == ""
            part += 1
        end

        if part == 0 # rules
            (id,desc) = split(line, ": ")
            id = parse(Int, id)
            if (desc == "\"a\"" || desc == "\"b\"")
                desc = strip(desc, ['\"'])
                rules[id] = desc
                terminals = [terminals; id]
                continue
            end

            parts = split(desc, " | ")
            for part in parts
                seq = split(part, " ")
                for s in seq
                    oid = parse(Int, s)
                    if oid in keys(graph)
                        graph[oid] = [graph[oid]; id] 
                    else
                        graph[oid] = [id]
                    end
                end
            end

            rules[id] = string("(",
                join(
                    map(
                        p->string("(",join(
                            map(s->string("(",s, ")"),split(p, " "))
                            ),")"), 
                        parts), 
                    "|"),
                ")")
        end

        if part == 1 #input
            phrases = [phrases; line]
        end
    end

    # Reduce, starting from terminals
    red(terminals, graph, rules)

    return rules,phrases
end

function part1()
    (rules,phrases) = input("day19.txt", false)
    re = Regex(string("^",rules[0],"\$"))
    cnt = count(s->match(re,s) != nothing, phrases)
    print(cnt)
end

function part2()
    (rules,phrases) = input("day19.txt", true)

    cnts = []
    for reps in 1:5 # checked if cnt goes to 5
        # Manipulate regexp to add repetitions
        res = string("^",rules[8],"+",rules[42],"{",reps,"}",rules[31],"{",reps,"}","\$")
        cnt = count(s->match(Regex(res),s) != nothing, phrases)
        cnts = [cnts; cnt]
    end
    
    print(sum(cnts),"\n")
end

part1()
print("\n")
part2()
