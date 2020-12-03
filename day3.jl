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

k = [3,1]
s = [1,1]
trees = 0
while s[2] < y
    s .+= k
    if field[(s[1]-1)%x+1,s[2]]
        global trees += 1
    end
end
print(trees)