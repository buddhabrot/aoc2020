using DelimitedFiles
data = readdlm("day2.txt", ' ')

function is_valid_entry(min,max,char,str)
    has_min = str[min] == char
    has_max = str[max] == char
    return has_min ⊻ has_max
end
 
global v = 0
for i = 1:size(data,1)
    crit = data[i,1]
    (min,max) = tuple(parse.(Int,(split(crit,"-")))...)
    char = first(rstrip(data[i,2],':'))
    str = data[i,3]

    if (is_valid_entry(min,max,char,str))
        print(data[i,:])
        global v += 1
    end
end

print(v)