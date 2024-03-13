using DataStructures

f(x) = 4x-2
finv(y) = (y + 2) ÷ 4

position_re = r"[A-Z]"
stackno_re = r"\d+"
instruction_re = r"^\D+(\d+)\D+(\d+)\D+(\d+)$"



D = open("data/input05", "r") do f
    D = Dict{Int, Stack{String}}()
    
    while !eof(f)
        position_stack = Stack{String}()
        
        # read in the initial stacks
        r = readline(f)
        while !isnothing(match(position_re, r))
            push!(position_stack, r)
            r = readline(f)
        end

        # this should be the line containing the stack numbers
        # populate the dictionary with the values
        for m in eachmatch(stackno_re, r)
            D[parse(Int, m.match)] = Stack{String}()
        end

        # for each line in the position stack, read blocks and push to their respective stacks
        while !isempty(position_stack)
            r = pop!(position_stack)
            for m in eachmatch(position_re, r)
                push!(D[finv(m.offset)], m.match)
            end
        end

        # the next line should be a blank line
        readline(f)
        break
    end

    # read all the instruction
    while !eof(f)
        r = readline(f)
        m = match(instruction_re, r)
        count, from, to = parse.(Int, m)
        for _ in 1:count
            push!(D[to], pop!(D[from]))
        end 
    end

    return D
end

top = ""
for (k, s) in sort(D)
    top *= first(s)
end

@show top


# Part 2 - added an extra buffer stack to put the blocks into

D = open("data/input05", "r") do f
    D = Dict{Int, Stack{String}}()
    
    while !eof(f)
        position_stack = Stack{String}()
        
        # read in the initial stacks
        r = readline(f)
        while !isnothing(match(position_re, r))
            push!(position_stack, r)
            r = readline(f)
        end

        # this should be the line containing the stack numbers
        # populate the dictionary with the values
        for m in eachmatch(stackno_re, r)
            D[parse(Int, m.match)] = Stack{String}()
        end

        # for each line in the position stack, read blocks and push to their respective stacks
        while !isempty(position_stack)
            r = pop!(position_stack)
            for m in eachmatch(position_re, r)
                push!(D[finv(m.offset)], m.match)
            end
        end

        # the next line should be a blank line
        readline(f)
        break
    end

    # read all the instruction
    while !eof(f)
        r = readline(f)
        m = match(instruction_re, r)
        count, from, to = parse.(Int, m)

        buffer = Stack{String}()
        for _ in 1:count
            push!(buffer, pop!(D[from]))
        end 
        while !isempty(buffer)
            push!(D[to], pop!(buffer))
        end
    end

    return D
end

top = ""
for (k, s) in sort(D)
    top *= first(s)
end

@show top