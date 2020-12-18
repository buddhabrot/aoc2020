
cubes = hcat(map(collect,readlines("day17.txt"))...)
cubes = cat(cubes,dims=ndims(cubes)+1)
hypercubes = cat(cubes,dims=ndims(cubes)+1)

# Added a part 3 that uses hyper hyper cubes
hyperhypercubes = hypercubes

for i = 1:200
    global hyperhypercubes
    hyperhypercubes = cat(hyperhypercubes,dims=ndims(hyperhypercubes)+1)
end

print(size(hyperhypercubes))

function step(cubes)
    # Pad the cubes
    nd = ndims(cubes)
    pad = fill('.',(size(cubes).+fill(2,nd))...)
    for index in CartesianIndices(Tuple(size(cubes)))
        pad[index+CartesianIndex(fill(1,nd)...)] = cubes[index]
    end
    cubeIndices = CartesianIndices(Tuple(size(cubes).+fill(2,nd)))
    offsets = map(
        c->c-CartesianIndex(fill(2,nd)...),
        CartesianIndices(Tuple(fill(3,nd))))

    cubes = pad
    mcubes = copy(cubes)

    for index in cubeIndices
        activeNeighbours = 0
        for offset in offsets
            neighbour = index + offset
            if (neighbour == index)
                continue
            end
            
            if(checkbounds(Bool, cubes, neighbour))
                if(cubes[neighbour] == '#')
                    activeNeighbours += 1
                end
            end

            if (activeNeighbours > 3)
                break #optimize
            end
        end

        if (mcubes[index] == '#' && !(activeNeighbours == 2 || activeNeighbours == 3))
            mcubes[index] = '.'
        end

        if (mcubes[index] == '.' && activeNeighbours == 3)
            mcubes[index] = '#'
        end
    end

    return mcubes
end

function part1()
    global cubes

    for i = 1:6
        cubes = step(cubes)
    end
   
    print(length(cubes[cubes.=='#']))
end

function part2()
    global hypercubes

    for i = 1:6
        hypercubes = step(hypercubes)
    end
   
    print(length(hypercubes[hypercubes.=='#']))
end

function part3()
    global hyperhypercubes

    for i = 1:2
        hyperhypercubes = step(hyperhypercubes)
    end
   
    print(length(hyperhypercubes[hyperhypercubes.=='#']))
end

part1()
print("\n")
part2()
print("\n")
#part3()
print("\n")
#part2()
