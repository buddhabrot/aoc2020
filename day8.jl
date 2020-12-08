program = readlines("day8.txt")
pc = 1
acc = 0
visited = Dict()

function step(instruction)
    (op, arg) = split(instruction, ' ')
    if op == "nop"
        global pc += 1
    end

    if op == "jmp"
        global pc += parse(Int, arg)
    end

    if op == "acc"
        global acc += parse(Int, arg)
        global pc += 1
    end
end

function reset()
    global pc = 1
    global acc = 0    
    global visited = Dict()
end

# return false if an infinite loop
function executeUntilHalt(instructions)
    reset()
    steps = 0

    while true
        if (pc in keys(visited))
            return false
        end

        visited[pc] = true

        if (pc > length(instructions))
            return true
        end

        step(instructions[pc])
        steps += 1
    end
end

# Mutate the instructions by flipping the next jmp or nop
# Julia does not shine at this array in-place
# but it can be a lot better than this, sorry
function flip!(instructions, position)
    if (position > length(instructions))
        return false
    end
    instruction = instructions[position] 
    (op, arg) = split(instruction, ' ')

    if op == "acc"
        return instructions
    end

    if op == "nop"
        instructions[position] = string("jmp ", arg)

        return instructions
    end

    if op == "jmp"
        instructions[position] = string("nop ", arg)

        return instructions
    end
end


function part1()
    executeUntilHalt(program)
    print(acc)
end

function part2()
    instructions = readlines("day8.txt")

    reset()

    mutation = 1
    flipped = 0
    
    while(executeUntilHalt(instructions)==false) 
        if (flipped > 0)
            instructions = flip!(instructions, flipped) # flip back
        end
        instructions = flip!(instructions, mutation)
        flipped = mutation
        mutation += 1

        if (mutation > length(instructions))
            print("End of mutations ", mutation, "\n")
            break
        end
    end

    print(acc)
end

part2()