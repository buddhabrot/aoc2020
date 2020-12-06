lines = [readlines("day6.txt");""]
summary = Dict()
total = 0
first = true
for line in lines
    if length(line) == 0
         cnt = length(keys(summary))
         global total += cnt
         global summary = Dict()
         global first = true
         continue
    end

    if (first)
        for char in line
            summary[char] = true
        end
    else
        for char in keys(summary)
            if !(char in line)
                delete!(summary, char)
            end
        end
    end

    first = false
end

print(total)