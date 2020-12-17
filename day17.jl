
cubes = hcat(map(collect,readlines("day17.txt"))...)
cubes = cat(cubes,dims=ndims(cubes)+1)
hypercubes = cat(cubes,dims=ndims(cubes)+1)

function step(cubes)
    # Pad the cubes
    if (ndims(cubes) == 3)
        (xd,yd,zd) = size(cubes)
        pad = fill('.',xd+2,yd+2,zd+2)
        for index in CartesianIndices((1:xd,1:yd,1:zd))
            pad[index+CartesianIndex(1,1,1)] = cubes[index]
        end
        cubeIndices = CartesianIndices((1:xd+2,1:yd+2,1:zd+2))
        offsets = CartesianIndices((-1:1,-1:1,-1:1))
    else # ndims = 4
        (xd,yd,zd,wd) = size(cubes)
        pad = fill('.',xd+2,yd+2,zd+2,wd+2)
        for index in CartesianIndices((1:xd,1:yd,1:zd,1:wd))
            pad[index+CartesianIndex(1,1,1,1)] = cubes[index]
        end
        cubeIndices = CartesianIndices((1:xd+2,1:yd+2,1:zd+2,1:wd+2))
        offsets = CartesianIndices((-1:1,-1:1,-1:1,-1:1))
    end

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


part1()
print("\n")
part2()
