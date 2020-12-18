lines = readlines("day18.txt")

-(a,b) = a*b # define multiplication as being same precedence as +  :)
lines = map(s->replace(s,"*" => "-"), lines)

function part1()
    sum(map(s->eval(Meta.parse(s)), lines))
end

function part2()
    global lines
    ^(a,b) = a+b # define addition as being higher precedence 
    lines = map(s->replace(s,"+" => "^"), lines)
    sum(map(s->eval(Meta.parse(s)), lines))
end

part1()
print("\n")
part2()