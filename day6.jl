lines = [readlines("day6.txt");""]
summary = Dict()
total = 0
for line in lines
    if length(line) == 0
         cnt = length(keys(summary))
         global total += cnt
         global summary = Dict()
    end

    for char in line
        summary[char] = true
    end
end

print(total)