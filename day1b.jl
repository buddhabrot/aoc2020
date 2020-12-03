using DelimitedFiles
d = readdlm("day1.txt", '\t', Int64)
h = Dict{Int64,Int64}()

for n in d
    if haskey(h,n)
        h[n] += 1
    else
        h[n] = 1
    end
end

function find_number(current_sum, desired_sum, current_length, desired_length, current_numbers, h)
    if (current_sum == desired_sum && current_length == desired_length)
        print(current_sum, ",", current_numbers, ",", reduce(*, current_numbers), "\n")
        return
    end

    for (k,v) in h
        if (v < 1)
            continue
        end

        if (current_sum + k > desired_sum)
            continue
        end
        
        if (current_length < desired_length)
            h[k] -= 1
            find_number(current_sum + k, desired_sum, current_length + 1, desired_length, [current_numbers; k], h)
            h[k] += 1
        end
    end
end

find_number(0, 2020, 0, 3, [], h)