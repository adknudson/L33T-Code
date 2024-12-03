module Day02

function read_input(io)
    xs = Vector{Vector{Int}}()

    for line in eachline(io)
        x = parse.(Int, split(line))
        push!(xs, x)
    end

    return xs
end

function is_safe(x)
    d1 = diff(x)
    all(<(0), d1) || all(>(0), d1) || return false
    all(in.(abs.(d1), Ref(1:3)))
end

function is_safe_with_dampener(x)
    is_safe(x) && return true

    for i in eachindex(x)
        y = @view x[[j for j in eachindex(x) if j != i]]
        is_safe(y) && return true
    end

    return false
end

end

using .Day02
using Test

ex = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""

xs = Day02.read_input(IOBuffer(ex))
n1 = count(Day02.is_safe, xs)
n2 = count(Day02.is_safe_with_dampener, xs)

@test n1 == 2
@test n2 == 4

xs = open("./data/02.txt") do io
    Day02.read_input(io)
end

n1 = count(Day02.is_safe, xs)
n2 = count(Day02.is_safe_with_dampener, xs)
