lines = [readlines("day6.txt");""]
summary = Dict()
total = 0
first = true
for line in lines
    if length(line) == 0
         cnt = length(summary)
         global total += cnt
         global first = true
         continue
    end

    if (first)
        global summary = Set(line)
    else
        global summary = intersect(summary, Set(line))
    end

    first = false
end

print(total)