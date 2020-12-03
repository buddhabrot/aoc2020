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

for (k,v) in h
    r = 2020 - k
    if r == 1010
        if haskey(h, 1010) && h[1010] > 1
            print(r * k, "\n") 
        end
        continue
    end
    if haskey(h, r)
        print(k, ",", r, ",", r * k, "\n")
    end
end

