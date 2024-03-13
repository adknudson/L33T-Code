compare(left::Int, right::Int) = cmp(left, right)

function compare(left::Vector, right::Vector)
    !isempty(left) && isempty(right) && return 1
    isempty(left) && !isempty(right) && return -1
    isempty(left) && isempty(right) && return 0

    if length(left) < length(right)
        for i in eachindex(left)
            x = compare(left[i], right[i])
            x == 0 && continue
            return x
        end

        return -1
    elseif length(left) == length(right)
        for i in eachindex(left)
            x = compare(left[i], right[i])
            x == 0 && continue
            return x
        end

        return 0
    else # right longer than left
        for i in eachindex(right)
            x = compare(left[i], right[i])
            x == 0 && continue
            return x
        end

        return 1
    end
end

compare(left::Vector, right::Int) = compare(left, [right])
compare(left::Int, right::Vector) = compare([left], right)
compare(pair::NTuple{2, Any}) = compare(first(pair), last(pair))

isordered(pair::NTuple{2, Any}) = compare(pair) < 0

function read_inputs(path::AbstractString)
    open(path, "r") do io
        pairs = Vector{NTuple{2, Any}}()
        while !eof(io)
            left = readline(io) |> Meta.parse |> eval
            right = readline(io) |> Meta.parse |> eval
            push!(pairs, (left, right))
            readline(io)
        end
        
        return pairs
    end
end

pairs = read_inputs("data/input13")
findall(isordered, pairs) |> sum


isless2(a, b) = compare(a, b) < 0

pairs = read_inputs("data/input13")
items = [x for y in pairs for x in y]
push!(items, [[2]])
push!(items, [[6]])
sort!(items; lt=isless2)

findall(x -> x == [[2]] || x == [[6]], items) |> prod