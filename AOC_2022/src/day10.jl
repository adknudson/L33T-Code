using DataStructures: Queue, enqueue!, dequeue!
using IterTools

function populate_buffer(path::AbstractString)
    buf = Queue{Union{Symbol, Int}}()
    open(path, "r") do io
        while !eof(io)
            r = readline(io)
            s = split(r)
            
            if first(s) == "noop"
                enqueue!(buf, :noop)
                continue
            elseif first(s) == "addx"
                enqueue!(buf, :addx)
                enqueue!(buf, parse(Int, last(s)))
            else
                error("Unrecognized command")
            end
        end
    end

    return buf
end


function process_instructions(instructions::Queue)
    register_history = Vector{Int}()
    x = 1
    push!(register_history, x)

    while !isempty(instructions)
        op = dequeue!(instructions)
        
        if op == :noop
            push!(register_history, x)
        elseif op == :addx
            push!(register_history, x)
            y = dequeue!(instructions)
            if y isa Int
                x += y
                push!(register_history, x)
            else
                error("Expected an integer. Got: '$y'")
            end
        else
            error("Unrecognized instruction: '$op'")
        end

    end

    return register_history
end

instructions = populate_buffer("data/input10")
register = process_instructions(instructions)

register[20:40:220] .* (20:40:220) |> sum

IterTools.partition(register, 40)


function print_instructions(register)
    for row in IterTools.partition(register, 40)
        pixel_pos = 0

        for cursor_pos in row
            print(pixel_pos ∈ (-1:1) .+ cursor_pos ? "#" : " ")
            pixel_pos += 1
        end

        print("\n")
    end
end

print_instructions(register)