using DelimitedFiles, Mmap
m = readdlm("day3.txt")
y = size(m)[1]
x = length(m[1,:][1])

field = Matrix{Bool}(undef,x,y)

for i = 1:y
    for j = 1:x
        w = m[i,:][1]
        field[j,i] = w[j] == '#'
    end
end

function count_slope(k)
    s = [1,1]
    trees = 0
    while s[2] < y
        s .+= k
        if field[(s[1]-1)%x+1,s[2]]
            trees += 1
        end
    end
    return trees
end

slopes = [(1,1),(3,1),(5,1),(7,1),(1,2)]
reduce(*,map(count_slope, slopes))
